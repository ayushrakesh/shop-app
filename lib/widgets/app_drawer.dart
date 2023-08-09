import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Hello Friend!',
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Color.fromARGB(255, 78, 1, 92),
            ),
            title: Text(
              'Shop',
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                '/',
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Color.fromARGB(255, 78, 1, 92),
            ),
            title: Text(
              'Orders',
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                OrdersScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Color.fromARGB(255, 78, 1, 92),
            ),
            title: Text(
              'Manage Products',
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                UserProductsScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 78, 1, 92),
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.deepPurple,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
