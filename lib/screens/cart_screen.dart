import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-details';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            color: Color.fromARGB(255, 255, 236, 254),
            elevation: 6,
            margin: EdgeInsets.all(
              15,
            ),
            child: Padding(
              padding: EdgeInsets.all(
                8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cartData.totalAmount.toStringAsFixed(
                        2,
                      ),
                      style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium!
                            .color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(
                    cartData: cartData,
                    orderData: orderData,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.itemsCount,
              itemBuilder: (ctx, index) => CartItem(
                cartData.items.values.toList()[index].id,
                cartData.items.values.toList()[index].title,
                cartData.items.values.toList()[index].price,
                cartData.items.values.toList()[index].quantity,
                cartData.items.keys.toList()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    required this.cartData,
    required this.orderData,
  });

  final Cart cartData;
  final Orders orderData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartData.totalAmount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await widget.orderData.addOrder(
                  widget.cartData.items.values.toList(),
                  widget.cartData.totalAmount);
              setState(() {
                isLoading = false;
              });
              widget.cartData.clear();
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
              ),
            ),
    );
  }
}
