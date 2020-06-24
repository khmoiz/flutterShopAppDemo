import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/providers/auth_provider.dart';

class LoginRegisterTab extends StatefulWidget {
  LoginRegisterTab({Key key}) : super(key: key);

  @override
  _LoginRegisterTabState createState() => _LoginRegisterTabState();
}

class _LoginRegisterTabState extends State<LoginRegisterTab> {
  String email, password, nickname, number;
  final _form = GlobalKey<FormState>();
  var passwordNode = FocusNode();
  var nicknameNode = FocusNode();
  var numberNode = FocusNode();
  final regExNumber =
      new RegExp('^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*\$');

  @override
  void _saveForm() {
//    var newID =
//        Provider.of<>(context, listen: false);
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Provider.of<AuthProvider>(context, listen: false)
          .signUp(email, password, nickname, number)
          .catchError((onError) {
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 6),
          content: Text('${onError.toString()}'),
        ));
      }).timeout(Duration(seconds: 6), onTimeout: () {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Request Timed Out! Please try again')));
      });
    }
  }

  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
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
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(nicknameNode),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Display Name'),
                textInputAction: TextInputAction.next,
                focusNode: nicknameNode,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(numberNode),
                onSaved: (value) {
                  nickname = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a Display Name for your account";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: numberNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(passwordNode),
                onSaved: (value) {
                  number = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a Number for your account";
                  } else if (!(regExNumber.hasMatch(value))) {
                    return "Please enter a valid phone number (North America)";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text(
                    'Create an Account!',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    _saveForm();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
