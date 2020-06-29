import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:providerapp/models/auth_status.dart';
import 'package:providerapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const SP_LOGGEDIN = 'logged-in';
  String _token, _userId;
  DateTime _expiryDate;
  User _currentUser;
  String facebookClientId = "795517274188196";
  String facebookRedirectUrl =
      "https://www.facebook.com/connect/login_success.html";
  List<String> _userFavourites = [];

  String smsOtp, verificationId, errorMessage;
  bool loggedIn, loading = false;
  AuthStatus _status = AuthStatus.Uninitialized;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCredential pCredential;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  AuthProvider();

  AuthProvider.initialize() {
//    readPrefs();
  }

  Future<void> readPrefs() async {
    await Future.delayed(Duration(seconds: 2)).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loggedIn = prefs.getBool(SP_LOGGEDIN) ?? false;
      print("§§§§§§§§ ${loggedIn.toString()} happened here §§§§§§§§");

      if (loggedIn) {
        _userId = (await _auth.currentUser()).uid;
        notifyListeners();
        return;
      }
    });
  }

  Future<void> demoVerifyPhone(BuildContext context) async {
//    final PhoneCodeSent smsOtpSent = (String verId, [int forceCodeResend]) {
//      this.verificationId = verId;
//      smsOTPDialog(context).then((value) {
//        print("signed in from dialogue");
//      });
//    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: ("+14167224564"),
          timeout: const Duration(seconds: 15),
          verificationCompleted: (AuthCredential phoneCredential) {
            print(
                "§§§§§§ AuthCredential :  ${phoneCredential.toString()} §§§§§§");
            this.pCredential = phoneCredential;
            signInPhone(context);
            _status = AuthStatus.Authenticated;
            notifyListeners();
          },
          verificationFailed: (AuthException exception) {
            print("§§§§§ AuthException :  ${exception.message} §§§§§§");
            throw ("Verification Failed");
            _status = AuthStatus.Uninitialized;
            notifyListeners();
          },
          codeSent: (verificationId, [code]) =>
              _smsCodeSent(verificationId, [code]),
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
            smsOTPDialog(context).then((_) {
              signInPhone(context).then((value) {
                _status = (value)
                    ? AuthStatus.Authenticated
                    : AuthStatus.Unauthenticated;
                notifyListeners();
              });
            });
          });
    } catch (e) {
//      handleError(e, context);
      errorMessage = (e as PlatformException).message;
      notifyListeners();
      throw ((e as PlatformException).message);
    }
  }

  Future<void> verifyPhone(BuildContext context, String number) async {
//    final PhoneCodeSent smsOtpSent = (String verId, [int forceCodeResend]) {
//      this.verificationId = verId;
//      smsOTPDialog(context).then((value) {
//        print("signed in from dialogue");
//      });
//    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: ("+1" + number.trim()),
          timeout: const Duration(seconds: 15),
          verificationCompleted: (AuthCredential phoneCredential) {
            print(
                "§§§§§§ AuthCredential :  ${phoneCredential
                    .toString()} §§§§§§");
            this.pCredential = phoneCredential;
            signInPhone(context);
            _status = AuthStatus.Authenticated;
            notifyListeners();
          },
          verificationFailed: (AuthException exception) {
            print("§§§§§ AuthException :  ${exception.message} §§§§§§");
            throw ("Verification Failed");
            _status = AuthStatus.Uninitialized;
            notifyListeners();
          },
          codeSent: (verificationId, [code]) =>
              _smsCodeSent(verificationId, [code]),
          codeAutoRetrievalTimeout: (String verId) async {
            this.verificationId = verId;
            await smsOTPDialog(context).then((_) async {
              await signInPhone(context).then((value) {
                _status = (value)
                    ? AuthStatus.Authenticated
                    : AuthStatus.Unauthenticated;
                notifyListeners();
              });
            });
          });
    } catch (e) {
//      handleError(e, context);
      errorMessage = (e as PlatformException).message;
      notifyListeners();
      throw ((e as PlatformException).message);
    }
  }

  _smsCodeSent(String vId, List<int> code) {
    this.verificationId = vId;
  }

  Future<void> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctxt) {
          return AlertDialog(
            title: Text('Enter SMS Code'),
            contentPadding: EdgeInsets.all(10),
            content: Container(
              height: 85,
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      this.smsOtp = value;
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  AuthStatus get status => _status;

  User get user {
    return _currentUser;
  }

  List<String> get userFavItems {
    return _userFavourites;
  }

  Future<User> demoSignInPhone(BuildContext context, String number) async {
    var user = await showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('AUTHTEST '),
          content: Text('$number'),
          actions: <Widget>[
            FlatButton(
              child: Text('Go to my Home Page'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    ).then((value) {
      Future.delayed(Duration(seconds: 2));
      return new User.emptyUser(nickName: "Moiz Khan", phoneNumber: number);
    });
    return Future.value(user);
  }

  Future<bool> signInPhone(BuildContext context, {bool timeOut = false}) async {
    bool verified = false;
    try {
      final AuthCredential credential = (timeOut)
          ? PhoneAuthProvider.getCredential(
          verificationId: this.verificationId, smsCode: this.smsOtp)
          : this.pCredential;
      await _auth
          .signInWithCredential(credential)
          .then((AuthResult result) async {
        if (result != null) {
          _currentUser = new User.newUserFromAuth(result.user, "Local");
          await getUserDataFromStore(user.id).then((DocumentSnapshot snapShot) {
            if (snapShot == null || !(snapShot.exists)) {
              writeNewUserData(_currentUser);
              getUserFavourites();
            } else {
              getUserDataFromStore(_currentUser.id);
              getUserFavourites();
            }
            verified = true;
            notifyListeners();
//          Navigator.of(context).pushNamed(ProductsOverview.routeName);
          });
          //        Navigator.of(context).pushNamed(ProductsOverview.routeName);

        }
      });
//
      return verified;
    } on PlatformException catch (e) {
//      handleError(e, context);
      errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp(String email, String password, String nickname,
      String number) async {
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
          _currentUser = new User.newUserFromAuth(result.user, "Google");
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
            _currentUser = new User.newUserFromAuth(result.user, "Apple");
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
