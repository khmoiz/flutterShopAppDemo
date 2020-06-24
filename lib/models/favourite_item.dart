import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavouriteItem with ChangeNotifier {
  final String id;

  FavouriteItem({@required this.id});

  FavouriteItem.emptyProduct({this.id = ''});

  FavouriteItem.fromFirestore(DocumentSnapshot firestoreSnap)
      : id = firestoreSnap['id'];
}
