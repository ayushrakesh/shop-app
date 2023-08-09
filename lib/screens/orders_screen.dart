import 'package:flutter/material.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<Orders>(context, listen: false).fetchOrders().then(
          (_) => setState(
            () {
              isLoading = false;
            },
          ),
        );
    super.initState();
  }
  // }() {
  //   if (isInit) {
  //     setState(() {

  //     });

  //   }
  //   isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (orderData.orders.isEmpty
              ? Center(
                  child: Text(
                    'No Orders yet!',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) => OrderItem(
                    orderData.orders[index],
                  ),
                )),
      drawer: AppDrawer(),
    );
  }
}
