import 'package:flutter/material.dart';
import 'package:providerapp/widgets/app_drawer.dart';

class DemoUserHomeScreen extends StatefulWidget {
  static const routeName = '/demo-home';

  DemoUserHomeScreen({Key key}) : super(key: key);

  @override
  _DemoUserHomeScreenState createState() => _DemoUserHomeScreenState();
}

class _DemoUserHomeScreenState extends State<DemoUserHomeScreen> {
  String email, password, nickname, number;
  final _form = GlobalKey<FormState>();
  var passwordNode = FocusNode();
  var nicknameNode = FocusNode();
  var numberNode = FocusNode();
  final regExNumber =
      new RegExp('^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome Demo'),
        ),
        drawer: AppDrawer(),
        body: bodyContent(context));
  }

  bodyContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Welcome User'),
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
            TextFormField(
              decoration: InputDecoration(labelText: 'Photo URL'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: numberNode,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(passwordNode),
              onSaved: (value) {
                number = value;
              },
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              child: Text('Update Details'),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text('Go Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
