import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/order_provider.dart';
import 'package:providerapp/widgets/order_item.dart' as ord;

import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) =>
              ord.OrderItem(orderData.orders[index])),
    );
  }
}
