import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/models/product.dart';
import 'package:providerapp/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
//  final Product _product;

  static const routeName = '/product-detail';

  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final _product = Provider.of<ProductsProvider>(context).findById(productID);

    return Scaffold(
        appBar: AppBar(
          title: Text('${_product.title}'),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: [
                Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(_product.imageURL),
                    )),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 5,
                  height: 5,
                ),
                Text("${_product.description}"),
                Text("${_product.price.toString()}\$"),
                Text("${_product.isFavourite.toString()}"),
                IconButton(
                  color: Colors.redAccent,
                  icon: Icon(_product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    _product.toggleFavourite();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
