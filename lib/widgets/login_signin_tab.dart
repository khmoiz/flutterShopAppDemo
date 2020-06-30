import 'dart:io';

import 'package:apple_sign_in/scope.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/auth_provider.dart';
import 'package:providerapp/screens/products_overview_screen.dart';

class LoginSigninTab extends StatefulWidget {
  @override
  _LoginSigninTabState createState() => _LoginSigninTabState();
}

class _LoginSigninTabState extends State<LoginSigninTab> {
  String email, password, nickname, number;
  final _form = GlobalKey<FormState>();
  var passwordNode = FocusNode();

  void signInWithAuth() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Provider.of<AuthProvider>(context, listen: false)
          .signIn(email, password)
          .then((_) {
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Login Successful!')));
        Navigator.of(context).pushNamed(ProductsOverview.routeName);
      }).catchError((onError) {
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 6),
          content: Text('${onError.toString()}'),
        ));
        Navigator.of(context).pushNamed(ProductsOverview.routeName);
      }).timeout(Duration(seconds: 6), onTimeout: () {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Request Timed Out! Please try again')));
      });
    }
  }

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

  void signInWithFacebook(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false)
        .signInUsingFacebook(context)
        .catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 6),
        content: Text('${onError.toString()}'),
      ));
    }).timeout(Duration(seconds: 160), onTimeout: () {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Request Timed Out! Please try again')));
    }).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 6), content: Text('Login Successful!')));
      Navigator.of(context).pushNamed(ProductsOverview.routeName);
    });
  }

  void signInWithApple(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).signInWithApple(
        scopes: [Scope.email, Scope.fullName]).catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 6),
        content: Text('${onError.toString()}'),
      ));
    }).timeout(Duration(seconds: 160), onTimeout: () {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Request Timed Out! Please try again')));
    }).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 4), content: Text('Login Successful!')));
      Navigator.of(context).pushNamed(ProductsOverview.routeName);
    });
  }

  appleSignInButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: RaisedButton(
          color: Colors.black,
          child: Text(
            'Sign In using Apple',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            signInWithApple(context);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Text('Please enter your:'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(passwordNode),
                onSaved: (value) {
                  email = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter an email";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                focusNode: passwordNode,
//                onFieldSubmitted: (_) =>
                onSaved: (value) {
                  password = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a password";
                  } else if (value.length < 6) {
                    return "Please enter password longer than 5 characters";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text(
                    'Sign In (Email & Password)',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    signInWithAuth();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RaisedButton(
                  color: Colors.white,
                  child: Text(
                    'Sign In Using Google Account',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    'Sign In using Facebook',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    signInWithFacebook(context);
                  },
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.all(5.0),
//                child: RaisedButton(
//                  color: Colors.white,
//                  child: Text(
//                    'Sign In using Twitter',
//                    style: TextStyle(
//                        fontSize: 15,
//                        fontWeight: FontWeight.bold,
//                        color: Colors.blueAccent),
//                  ),
//                  onPressed: () {},
//                ),
//              ),
              (Platform.isIOS)
                  ? appleSignInButton(context)
                  : SizedBox(
                      width: 0,
                      height: 0,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
