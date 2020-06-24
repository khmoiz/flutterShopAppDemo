import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/models/user.dart';
import 'package:providerapp/providers/auth_provider.dart';
import 'package:providerapp/providers/carts_provider.dart';
import 'package:providerapp/screens/product_detail_screen.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product _product = Provider.of<Product>(context, listen: false);
    CartsProvider _cart = Provider.of<CartsProvider>(context, listen: false);
    User _currentUser = Provider.of<AuthProvider>(context, listen: false).user;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: _product.id);
          },
          child: Image.network(
            _product.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        header: SizedBox(
          child: Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment.topRight,
            width: 10,
            child: Card(
              color: Colors.purpleAccent,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "${_product.price.toString()}\$",
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              color: Colors.purpleAccent,
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavourite(_currentUser.id);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.yellow,
            onPressed: () {
              _cart.addItem(_product.id, _product.price, _product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added Item to Cart!',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    _cart.removeSingleItem(_product.id);
                  },
                ),
              ));
            },
          ),
          title: Center(
            child: Text(
              _product.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontSize: 13, color: Colors.yellowAccent, wordSpacing: 1),
            ),
          ),
        ),
      ),
    );
  }
}
