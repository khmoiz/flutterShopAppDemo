import 'package:flutter/cupertino.dart';

import 'carts_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(@required this.id, @required this.amount, @required this.products,
      @required this.dateTime);
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
            DateTime.now().toString(), total, cartProducts, DateTime.now()));
    notifyListeners();
  }
}
