import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import '../models/http_exception.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl: 'https://i.ebayimg.com/images/g/aB8AAOSwndxgbZSb/s-l500.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findProductBy(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get findFavs {
    return _items.where((product) => product.isFavourite == true).toList();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://second-project-fff01-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url as Uri,
        body: json.encode(
          {
            'creatorId': userId,
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      final newProd = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        isFavourite: product.isFavourite,
      );

      _items.add(newProd);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchProducts([bool isUserProducts = false]) async {
    final filterString = '&orderBy="creatorId"&equalTo="$userId"';
    var url = isUserProducts
        ? Uri.parse(
            'https://second-project-fff01-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString')
        : Uri.parse(
            'https://second-project-fff01-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    final response = await http.get(
      url,
    );

    print(response);
    print(response.body);
    print(json.decode(response.body));

    if (response.body == null) {
      return;
    }
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    final List<Product> loadedProducts = [];

    url = Uri.parse(
        'https://second-project-fff01-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken');

    final favResponse = await http.get(url);
    final favResponseData = json.decode(favResponse.body);

    print(favResponseData);

    extractedData.forEach(
      (prodId, prodData) {
        // prodData = prodData.tojson();
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isFavourite: favResponseData == null
                ? false
                : favResponseData[prodId] ?? false,
            price: (prodData['price']),
          ),
        );
      },
    );
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      final url =
          'https://second-project-fff01-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

      http.patch(
        url as Uri,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );

      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://second-project-fff01-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    final response = await http.delete(url as Uri);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(
        'Could not delete product!',
      );
    }
  }
}
