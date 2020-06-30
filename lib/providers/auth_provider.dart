import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:providerapp/models/user.dart';
import 'package:providerapp/widgets/socialAuth/facebook_web_view.dart';

class AuthProvider extends ChangeNotifier {
  String _token, _userId;
  DateTime _expiryDate;
  User _currentUser;
  String facebookClientId = "795517274188196";
  String facebookRedirectUrl =
      "https://www.facebook.com/connect/login_success.html";
  List<String> _userFavourites = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  User get user {
    return _currentUser;
  }

  List<String> get userFavItems {
    return _userFavourites;
  }

  Future<void> signUp(
      String email, String password, String nickname, String number) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((onError) {
      print(onError.toString());
      throw Exception(
          "${(onError as PlatformException).code} | ${(onError as PlatformException).message}");
    }).then((AuthResult result) {
      User newUser = new User(
          id: result.user.uid,
          type: "local",
          email: email,
          nickName: nickname,
          phoneNumber: number);
      writeNewUserData(newUser);
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((AuthResult result) {
      updateCurrentUser(result.user);
      getUserFavourites();
      notifyListeners();
    }).catchError((onError) {
      _currentUser = null;
      notifyListeners();
      throw Exception("${(onError as PlatformException).code}");
    });
  }

  Future<void> signInUsingGoogle() async {
    GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn().catchError((onError) {
      throw Exception("${(onError as PlatformException).code}");
    });
    if (googleSignInAccount != null) {
      try {
        GoogleSignInAuthentication signInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: signInAuthentication.accessToken,
          idToken: signInAuthentication.idToken,
        );

        await _auth
            .signInWithCredential(credential)
            .then((AuthResult result) async {
          _currentUser = new User.fromUserAuth(result.user, "Google");
          await getUserDataFromStore(result.user.uid)
              .then((DocumentSnapshot snapShot) {
            if (snapShot == null || !(snapShot.exists)) {
              writeNewUserData(_currentUser);
              getUserFavourites();
            } else {
              getUserDataFromStore(_currentUser.id);
              getUserFavourites();
            }
            notifyListeners();
          });
        }).catchError((onError) {
          throw Exception("${(onError as PlatformException).code}");
        });
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  Future<void> signInUsingFacebook(BuildContext context) async {
    String facebookResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FacebookWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=$facebookClientId&redirect_uri=$facebookRedirectUrl&response_type=token&scope=email,public_profile,',
              ),
          maintainState: true),
    );

    if (facebookResult != null) {
      try {
        final facebookAuthCred =
            FacebookAuthProvider.getCredential(accessToken: facebookResult);
        await _auth
            .signInWithCredential(facebookAuthCred)
            .then((AuthResult result) async {
          _currentUser = new User.fromUserAuth(result.user, "Facebook");
          await getUserDataFromStore(result.user.uid)
              .then((DocumentSnapshot snapShot) {
            if (snapShot == null || !(snapShot.exists)) {
              writeNewUserData(_currentUser);
              getUserFavourites();
            } else {
              getUserDataFromStore(_currentUser.id);
              getUserFavourites();
            }
            notifyListeners();
          });
        }).catchError((onError) {
          throw Exception("${(onError as PlatformException).code}");
        });
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  Future<void> getUserFavourites() async {
    _userFavourites.clear();
    await _db
        .collection("users")
        .document(_currentUser.id)
        .collection("favourites")
        .where("isFavourite", isEqualTo: true)
        .getDocuments()
        .then((snapShot) => {
              print("${snapShot.toString()}"),
              snapShot.documents.forEach((favItem) {
                _userFavourites.add(favItem['id']);
                print('${favItem['id']}');
              }),
            });
    notifyListeners();
  }

  Future<void> signInUsingTwitter(BuildContext context) async {
    String twitterResult = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FacebookWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=$facebookClientId&redirect_uri=$facebookRedirectUrl&response_type=token&scope=email,public_profile,',
              ),
          maintainState: true),
    );

    if (twitterResult != null) {
      try {
        final facebookAuthCred =
            FacebookAuthProvider.getCredential(accessToken: twitterResult);
        await _auth
            .signInWithCredential(facebookAuthCred)
            .then((AuthResult result) async {
          _currentUser = new User.fromUserAuth(result.user, "Facebook");
          await getUserDataFromStore(result.user.uid)
              .then((DocumentSnapshot snapShot) {
            if (snapShot == null || !(snapShot.exists)) {
              writeNewUserData(_currentUser);
            } else {
              getUserDataFromStore(_currentUser.id);
            }
            notifyListeners();
          });
        }).catchError((onError) {
          throw Exception("${(onError as PlatformException).code}");
        });
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  static Future<bool> checkAppleSignIn() async {
    return await AppleSignIn.isAvailable();
  }

  Future<void> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    bool appleSignInCheck = await checkAppleSignIn();
    if (appleSignInCheck) {
      // 2. check the result
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider(providerId: 'apple.com');
          final credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          await _auth
              .signInWithCredential(credential)
              .then((AuthResult result) async {
            _currentUser = new User.fromUserAuth(result.user, "Apple");
            await getUserDataFromStore(result.user.uid)
                .then((DocumentSnapshot snapShot) {
              if (snapShot == null || !(snapShot.exists)) {
                writeNewUserData(_currentUser)
                    .then((value) => {getUserFavourites()});
              } else {
                getUserDataFromStore(_currentUser.id)
                    .then((value) => {getUserFavourites()});
              }
              notifyListeners();
            });
          }).catchError((onError) {
            throw Exception("${(onError as PlatformException).code}");
          });

          break;
        case AuthorizationStatus.error:
          print(result.error.toString());
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );
          break;

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
          break;
      }
    }
  }

  Future<FirebaseUser> getStoredUserFromAuth() async {
    return await _auth.currentUser();
  }

  Future<void> updateCurrentUser(FirebaseUser firebaseUser) async {
    getStoredUserFromAuth().then((FirebaseUser firebaseUser) async => {
          getUserDataFromStore(firebaseUser.uid)
              .then((DocumentSnapshot userSnap) {
            _currentUser = new User.fromFirestore(userSnap);
            print(_currentUser.createMap().toString());
            notifyListeners();
          })
        });
  }

  Future<void> signOutUser(BuildContext context) async {
    _auth.signOut().then((_) {
      _currentUser = null;
      notifyListeners();
    });
  }

  Future<DocumentSnapshot> getUserDataFromStore(String uid) async {
    return await _db.collection("users").document("$uid").get();
  }

  Future<void> writeNewUserData(User newUser) async {
    await _db
        .collection("users")
        .document("${newUser.id}")
        .setData(newUser.createMap());
  }
}
