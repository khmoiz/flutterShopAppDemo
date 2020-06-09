import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/screens/product_detail_screen.dart';
import '../models/product.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product _product = Provider.of<Product>(context, listen: false);
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
                product.toggleFavourite();
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.yellow,
            onPressed: () {},
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
