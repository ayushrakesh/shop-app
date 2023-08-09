import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  final height = Get.height;
  final width = Get.width;
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);

    final productData = Provider.of<Product>(
      context,
      listen: false,
    );
    final cartData = Provider.of<Cart>(context, listen: false);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            18,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: productData.id,
              );
            },
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black87,
                leading: Consumer<Product>(
                  builder: (context, value, child) => IconButton(
                    icon: productData.isFavourite
                        ? Icon(
                            Icons.favorite_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    onPressed: () => productData.toggleFavouriteStatus(
                        authData.getToken!, authData.getUserId!),
                  ),
                ),
                title: Text(
                  productData.title,
                  style: TextStyle(
                      // letterSpacing: 1.0,
                      ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.shopping_cart_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    cartData.addItem(
                        productData.title, productData.price, productData.id);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Item added to cart.',
                        ),
                        duration: const Duration(
                          seconds: 3,
                        ),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () =>
                              cartData.undoAddingItem(productData.id),
                          textColor: Color.fromARGB(255, 162, 254, 236),
                        ),
                      ),
                    );
                  },
                ),
              ),
              child: Hero(
                tag: productData.id,
                child: FadeInImage(
                  placeholder: AssetImage(
                    'assets/images/myshop.png',
                  ),
                  image: NetworkImage(
                    productData.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
