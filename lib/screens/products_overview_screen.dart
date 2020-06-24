import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/auth_provider.dart';
import 'package:providerapp/providers/carts_provider.dart';
import 'package:providerapp/providers/products_provider.dart';
import 'package:providerapp/screens/cart_screen.dart';
import 'package:providerapp/widgets/badge.dart';
import 'package:providerapp/widgets/product_item.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favourites,
  All,
}

//Products Overview Screen
class ProductsOverview extends StatefulWidget {
  static const routeName = '/products-home';

  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavourites = false;
  bool checkSignIn = false;
  @override
  void initState() {
    super.initState();

    Provider.of<ProductsProvider>(context, listen: false)
        .getProductsFromService();
    var authP = Provider.of<AuthProvider>(context, listen: false);
    var stateHolder = authP.user;
    if (stateHolder == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notLoggedIn(context);
      });
    } else {
      checkSignIn = true;
    }
  }

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false)
        .refreshProductsListFromService();
  }

  void notLoggedIn(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ProductsProvider data = Provider.of<ProductsProvider>(context);
//    data.getProductsFromService();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () {
//            data.saveData();
          },
        ),
        drawer: AppDrawer(),
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
                PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favourites,
                ),
              ],
            ),
            Consumer<CartsProvider>(
              builder: (_, cartData, staticChild) {
                return Badge(
                    value: cartData.itemCount.toString(), child: staticChild);
              },
              child: IconButton(
                icon: Icon(Icons.shopping_basket),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
          title: Text(
            'My Shop',
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: ProductsGrid(_showOnlyFavourites)));
  }
}

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavourites;

  ProductsGrid(this.showOnlyFavourites);

  @override
  Widget build(BuildContext context) {
    final ProductsProvider data = Provider.of<ProductsProvider>(context);

    final loadedProducts =
        showOnlyFavourites ? data.favouriteItems : data.items;

    return loadedProducts.isNotEmpty
        ? GridView.builder(
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
            })
        : Center(
            child: CircularProgressIndicator(
              strokeWidth: 10,
              backgroundColor: Colors.black,
              semanticsLabel: "Soething",
            ),
          );
  }
}
