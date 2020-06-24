import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/products_provider.dart';
import 'package:providerapp/widgets/app_drawer.dart';
import 'package:providerapp/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Products Master List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) => Column(
                  children: <Widget>[
                    UserProductItem(
                        productsData.items[index].id,
                        productsData.items[index].title,
                        productsData.items[index].imageURL),
                    Divider(),
                  ],
                )),
      ),
    );
  }
}
