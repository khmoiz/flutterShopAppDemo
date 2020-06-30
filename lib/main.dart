import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/auth_provider.dart';
import 'package:providerapp/providers/carts_provider.dart';
import 'package:providerapp/providers/order_provider.dart';
import 'package:providerapp/screens/cart_screen.dart';
import 'package:providerapp/screens/demo_user_home_screen.dart';
import 'package:providerapp/screens/edit_product_screen.dart';
import 'package:providerapp/screens/login_screen.dart';
import 'package:providerapp/screens/order_screen.dart';
import 'package:providerapp/screens/products_overview_screen.dart';
import 'package:providerapp/screens/user_favourite_products_screen.dart';
import 'package:providerapp/screens/user_products_screen.dart';

import './providers/products_provider.dart';
import './screens/product_detail_screen.dart';
import 'providers/products_provider.dart';

void main() {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = false;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => CartsProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider.initialize()),

//        ChangeNotifierProvider(create: (ctx) => locator<ProductCRUD>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          ProductsOverview.routeName: (context) => ProductsOverview(),
          DemoUserHomeScreen.routeName: (context) => DemoUserHomeScreen(),
          UserFavouriteProductsScreen.routeName: (context) =>
              UserFavouriteProductsScreen(),
        },
        theme: ThemeData(
            backgroundColor: Color.fromRGBO(220, 220, 220, 1),
            primarySwatch: Colors.purple,
            accentColor: Colors.purpleAccent,
            textTheme: GoogleFonts.latoTextTheme()),
        home: LoginScreen(),
      ),
    );
  }
}
