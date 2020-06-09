import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/products_provider.dart';
import 'package:providerapp/screens/product_detail_screen.dart';
import 'package:providerapp/widgets/product_item.dart';
import '../models/product.dart';

enum FilterOptions {
  Favourites,
  All,
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {},
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favourites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            )
          ],
          title: Text(
            'My Shop',
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: ProductsGrid());
  }
}

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductsProvider data = Provider.of<ProductsProvider>(context);
    final loadedProducts = data.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
              value: loadedProducts[index], child: ProductItem());
        });
  }
}
