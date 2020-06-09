import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        },
        theme: ThemeData(
            backgroundColor: Color.fromRGBO(220, 220, 220, 1),
            primarySwatch: Colors.purple,
            accentColor: Colors.purpleAccent,
            textTheme: GoogleFonts.latoTextTheme()),
        home: MyHomePage(),
      ),
    );
  }
}
