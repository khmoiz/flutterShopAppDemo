import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id, title, description, imageURL;
  final double price;
  bool isFavourite;
  Firestore _db = Firestore.instance;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageURL,
      @required this.price,
      this.isFavourite = false});

  Map<String, dynamic> createMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price.toString(),
      'imageUrl': imageURL,
      'isFavourite': isFavourite
    };
  }

  Product.emptyProduct(
      {this.id = '',
      this.title = '',
      this.description = '',
      this.imageURL = '',
      this.price = 0.0,
      this.isFavourite = false});

  Product.fromFirestore(DocumentSnapshot firestoreSnap)
      : id = firestoreSnap['id'],
        title = firestoreSnap['title'],
        description = firestoreSnap['description'],
        imageURL =
            firestoreSnap['imageUrl'] == null ? '' : firestoreSnap['imageUrl'],
        isFavourite = (firestoreSnap['isFavourite'] as bool),
        price = double.parse(firestoreSnap['price']);

  void toggleFavourite(String userId) {
    isFavourite = !isFavourite;

    _db
        .collection("users")
        .document(userId)
        .collection("favourites")
        .document("$id")
        .setData({"isFavourite": isFavourite}, merge: true).then((_) {
      print("success updating the favourites option");
    });

    _db
        .collection("products")
        .document(id)
        .updateData({"isFavourite": isFavourite}).then((_) {
      print("success updating the favourites option");
    }).then((value) {
      notifyListeners();
    });
  }
}
