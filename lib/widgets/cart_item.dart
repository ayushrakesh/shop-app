import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;
  final String id;

  final String productId;

  CartItem(this.id, this.title, this.price, this.quantity, this.productId);

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(
      context,
      listen: false,
    );

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.all(
          20,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Are you sure ?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cartData.removeItem(productId);
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            8,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepOrange,
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(
                  4,
                ),
                child: FittedBox(
                  child: Text(
                    '\$${price}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
            subtitle: Text('Total - \$${(price * quantity)}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
