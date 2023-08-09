import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyFavourites = false;
  var init = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (init) {
      setState(() {
        isLoading = true;
      });

      Provider.of<Products>(context).fetchProducts().then(
            ((value) => setState(
                  () {
                    isLoading = false;
                  },
                )),
          );
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final cartData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Favourites'),
                value: FilterOptions.favourites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.all,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (FilterOptions selectedValue) {
              setState(
                () {
                  if (selectedValue == FilterOptions.favourites) {
                    showOnlyFavourites = true;
                  } else {
                    showOnlyFavourites = false;
                  }
                },
              );
            },
          ),
          // Consumer<Cart>(
          //   builder: (_, cartData, ch) => Badge(
          //     child: ch,
          //     value: cartData.items.length.toString(),
          //   ),
          //   child: IconButton(
          //     icon: Icon(Icons.shopping_cart),
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(CartScreen.routeName);
          //     },
          //   ),
          // ),
          Consumer<Cart>(
            builder: (context, cartData, ch) => IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              showOnlyFavourites,
            ),
      drawer: AppDrawer(),
    );
  }
}
