import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id, title, description, imageURL;
  final double price;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageURL,
      @required this.price,
      this.isFavourite = false});

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
