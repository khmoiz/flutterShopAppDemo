import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/auth_provider.dart';
import 'package:providerapp/providers/products_provider.dart';
import 'package:providerapp/widgets/app_drawer.dart';
import 'package:providerapp/widgets/user_favourite_product_item.dart';

import 'products_overview_screen.dart';

class UserFavouriteProductsScreen extends StatefulWidget {
  static const routeName = '/user-favourite-products';

  @override
  _UserFavouriteProductsScreenState createState() =>
      _UserFavouriteProductsScreenState();
}

class _UserFavouriteProductsScreenState
    extends State<UserFavouriteProductsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userAuth = Provider.of<AuthProvider>(context, listen: false);
    userAuth.getUserFavourites();
    var productsData = Provider.of<ProductsProvider>(context)
        .userFavouriteItems(userAuth.userFavItems);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Favourite Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushNamed(ProductsOverview.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.length,
            itemBuilder: (context, index) => Column(
                  children: <Widget>[
                    UserFavouriteProductItem(
                        productsData[index].id,
                        productsData[index].title,
                        productsData[index].imageURL),
                    Divider(),
                  ],
                )),
      ),
    );
  }
}
