import 'dart:math';
import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 260,
      ),
      height:
          expanded ? min(widget.order.products.length * 30.0 + 100, 200) : 95,
      // expanded ? 200 : 95,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(
          6,
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$${widget.order.amount}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                DateFormat('dd-MM-yyyy      hh:mm').format(
                  widget.order.dateTime,
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple,
                ),
              ),
              trailing: IconButton(
                icon: !expanded
                    ? Icon(
                        Icons.expand_more,
                      )
                    : Icon(
                        Icons.expand_less,
                      ),
                onPressed: () {
                  setState(
                    () {
                      expanded = !expanded;
                    },
                  );
                },
              ),
            ),
            if (expanded)
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(
                    milliseconds: 260,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  height: expanded
                      ? min(widget.order.products.length * 30.0, 100)
                      : 0,
                  child: ListView.builder(
                    itemCount: widget.order.products.length,
                    itemBuilder: (ctx, index) => Container(
                      margin: EdgeInsets.only(
                        top: 4,
                      ),
                      height: 30,
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      color: Color.fromARGB(255, 246, 239, 248),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.order.products[index].title,
                            style: TextStyle(
                              color: Color.fromARGB(255, 70, 17, 80),
                            ),
                            // style: ,
                          ),
                          Text(
                              '${widget.order.products[index].quantity} x  ${widget.order.products[index].price}'),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
