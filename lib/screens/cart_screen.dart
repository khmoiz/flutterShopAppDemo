import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/carts_provider.dart';
import 'package:providerapp/providers/order_provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    CartsProvider _cart = Provider.of<CartsProvider>(context);
    var _items = _cart.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${_cart.totalSum.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'Confirm Order',
                      style: TextStyle(fontSize: 20),
                    ),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrder(
                              _cart.items.values.toList(), _cart.totalSum);
                      _cart.clearCart();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          new Expanded(
              child: ListView.builder(
                  itemCount: _cart.items.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    String key = _items.keys.elementAt(index);
                    return CartItemWidget(
                        _items[key].id,
                        key,
                        _items[key].title,
                        _items[key].price,
                        _items[key].quantity);
                  }))
        ],
      ),
    );
  }
}
