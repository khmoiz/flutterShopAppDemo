import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/models/auth_status.dart';
import 'package:providerapp/providers/auth_provider.dart';
import 'package:providerapp/screens/demo_user_home_screen.dart';
import 'package:providerapp/screens/products_overview_screen.dart';

class LoginSigninTab extends StatefulWidget {
  @override
  _LoginSigninTabState createState() => _LoginSigninTabState();
}

enum AuthType { Phone, Email }

class _LoginSigninTabState extends State<LoginSigninTab> {
  String otp;

  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _emailForm = GlobalKey<FormState>();
  final _phoneForm = GlobalKey<FormState>();
  var passwordNode = FocusNode();

  AuthType _currentAuth = AuthType.Phone;

  bool showOTPField = false;
  final regExNumber =
      new RegExp('^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*\$');

  void changeAuthType() {
    setState(() {
      if (_currentAuth == AuthType.Phone) {
        _currentAuth = AuthType.Email;
      } else {
        _currentAuth = AuthType.Phone;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              child: Text('Please enter your:'),
            ),
            (_currentAuth == AuthType.Phone)
                ? phoneLoginForm()
                : emailLoginForm(),
            authSignInButton(context, authProvider),
            (_currentAuth == AuthType.Email)
                ? googleSignInButton(context, authProvider)
                : Container(),
            RaisedButton(
              child: Text('Go Demo'),
              onPressed: () {
                Navigator.of(context).pushNamed(DemoUserHomeScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithAuth(
      BuildContext context, AuthProvider authProvider) async {
    switch (_currentAuth) {
      case AuthType.Email:
        if (_emailForm.currentState.validate()) {
          _emailForm.currentState.save();
          await showDialog(
            context: context,
            barrierDismissible: true,
            // false = user must tap button, true = tap outside dialog
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('Successfully Logged in!'),
                content: Text('Hey we found you!'),
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
            Navigator.of(context).pushNamed(DemoUserHomeScreen.routeName);
          });
//          authProvider.verifyPhone(context, number).then((_) {
//            Scaffold.of(context).showSnackBar(SnackBar(
//                duration: Duration(seconds: 2),
//                content: Text('Login Successful!')));
////        Navigator.of(context).pushNamed(ProductsOverview.routeName);
//          }).catchError((onError) {
//            Scaffold.of(context).showSnackBar(SnackBar(
//              duration: Duration(seconds: 6),
//              content: Text('${onError.toString()}'),
//            ));
////        Navigator.of(context).pushNamed(ProductsOverview.routeName);
//          }).timeout(Duration(seconds: 6), onTimeout: () {
//            Scaffold.of(context).showSnackBar(
//                SnackBar(content: Text('Request Timed Out! Please try again')));
//          });
        }
        break;
      case AuthType.Phone:
        if (_phoneForm.currentState.validate()) {
          _phoneForm.currentState.save();
//          await authProvider.verifyPhone(context, phoneTextController.text);
          await authProvider.demoVerifyPhone(context);
          if (authProvider.status == AuthStatus.Authenticated) {
            await showDialog(
              context: context,
              barrierDismissible: true,
              // false = user must tap button, true = tap outside dialog
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text(
                      'Successfully Logged ${authProvider.status.toString()}!'),
                  content: Text('Hey  we found you!'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Go to my Home Page'),
                      onPressed: () {
                        Navigator.of(dialogContext)
                            .pop(); // Dismiss alert dialog
                      },
                    ),
                  ],
                );
              },
            ).then((_) {
              Navigator.of(context).pushNamed(DemoUserHomeScreen.routeName);
            });
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('FAILED'),
            ));
          }

//          authProvider
//              .signIn(emailTextController.text, passwordTextController.text)
//              .then((_) {
//            Scaffold.of(context).showSnackBar(SnackBar(
//                duration: Duration(seconds: 2),
//                content: Text('Login Successful!')));
////        Navigator.of(context).pushNamed(ProductsOverview.routeName);
//          }).catchError((onError) {
//            Scaffold.of(context).showSnackBar(SnackBar(
//              duration: Duration(seconds: 6),
//              content: Text('${onError.toString()}'),
//            ));
////        Navigator.of(context).pushNamed(ProductsOverview.routeName);
//          }).timeout(Duration(seconds: 6), onTimeout: () {
//            Scaffold.of(context).showSnackBar(
//                SnackBar(content: Text('Request Timed Out! Please try again')));
//          });
        }
        break;
    }
  }

  void submitPhoneAuth() {}

  void submitEmailAuth() {}

  void signInWithGoogle(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false)
        .signInUsingGoogle()
        .catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 6),
        content: Text('${onError.toString()}'),
      ));
    }).timeout(Duration(seconds: 6), onTimeout: () {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Request Timed Out! Please try again')));
    }).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 6), content: Text('Login Successful!')));
      Navigator.of(context).pushNamed(ProductsOverview.routeName);
    });
  }

  authSignInButton(BuildContext context, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Container(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                (_currentAuth == AuthType.Phone)
                    ? 'Sign In Using Phone Number'
                    : 'Sign in Using Email',
                style: TextStyle(fontSize: 15),
              ),
              (_currentAuth == AuthType.Phone)
                  ? Icon(Icons.phone_locked)
                  : Icon(Icons.email),
            ],
          ),
        ),
        onPressed: () {
          signInWithAuth(context, authProvider);
        },
      ),
    );
  }

  googleSignInButton(BuildContext context, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: RaisedButton(
        color: Colors.white,
        child: Text(
          'Sign In Using Google Account',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        onPressed: () {
          signInWithGoogle(context);
        },
      ),
    );
  }

  phoneLoginForm() {
    return Form(
      key: _phoneForm,
      child: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: phoneTextController,
              decoration:
                  InputDecoration(labelText: 'Phone Number', prefixText: "+1"),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(passwordNode),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter a Number for your account";
                } else if (!(regExNumber.hasMatch(value))) {
                  return "Please enter a valid phone number (North America)";
                } else if (value.length != 10) {
                  return "Please enter a valid 10 Digit NA Phone number";
                }
                return null;
              },
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: FlatButton(
                  child: Text(
                    'Want to use Email instead?',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    changeAuthType();
                  },
                ))
          ],
        ),
      ),
    );
  }

  emailLoginForm() {
    return Form(
      key: _emailForm,
      child: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: emailTextController,
              decoration: InputDecoration(labelText: 'Email'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(passwordNode),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter an Email to sign in!";
                }
//              else if (!(regExNumber.hasMatch(value))) {
//                return "Please enter a valid phone number (North America)";
//              }
                return null;
              },
            ),
            TextFormField(
              controller: passwordTextController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(passwordNode),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter the password for you account!";
                } else if (value.length < 6) {
                  return "Please enter alteast 6 digits for your password!";
                }
                return null;
              },
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: FlatButton(
                  child: Text(
                    'Want to use your Phone number instead?',
                    style: TextStyle(color: Theme
                        .of(context)
                        .primaryColor),
                  ),
                  onPressed: () {
                    changeAuthType();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
