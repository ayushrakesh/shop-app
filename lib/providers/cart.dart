import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  String title;
  String id;
  double price;
  int quantity;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String title, double price, String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCardItem) => CartItem(
            id: existingCardItem.id,
            price: existingCardItem.price,
            quantity: existingCardItem.quantity + 1,
            title: existingCardItem.title),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total = total + (value.price * value.quantity);
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void undoAddingItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existingItem) {
          return CartItem(
            id: existingItem.id,
            price: existingItem.price,
            quantity: existingItem.quantity - 1,
            title: existingItem.title,
          );
        },
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
