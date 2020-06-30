import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable with ChangeNotifier {
  final String id, nickName, email, phoneNumber, type;
  Firestore _db = Firestore.instance;

  User(
      {@required this.id,
      @required this.nickName,
      @required this.email,
      @required this.type,
      @required this.phoneNumber});

  Map<String, dynamic> createMap() {
    return {
      'id': id,
      'nickName': nickName,
      'email': email,
      'type': type,
      'phoneNumber': phoneNumber,
    };
  }

  User.emptyUser(
      {this.id = '',
      this.nickName = '',
      this.email = '',
      this.type = '',
      this.phoneNumber = ''});

  User.fromFirestore(DocumentSnapshot firestoreSnap)
      : id = firestoreSnap['id'],
        nickName = firestoreSnap['nickName'],
        email = firestoreSnap['email'],
        type = firestoreSnap['type'],
        phoneNumber = firestoreSnap['phoneNumber'];

  User.newUserFromAuth(FirebaseUser user, String accountType)
      : id = user.uid,
        nickName = (user.displayName == null || user.displayName == '')
            ? ''
            : user.displayName,
        email = (user.email == null || user.email == '') ? '' : user.email,
        type = accountType,
        phoneNumber = user.phoneNumber;

  void toggleFavourite(String id, bool favourite) {
    _db
        .collection("users")
        .document(id)
        .updateData({"isFavourite": favourite}).then((_) {
      print("success updating the favourites option");
    });
    notifyListeners();
  }

  @override
  String toString() {
    return "ID [$id] | Name [$nickName] | Email [$email] | Number [$phoneNumber] ";
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, email, nickName, phoneNumber, type];
}
