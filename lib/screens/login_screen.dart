import 'package:flutter/material.dart';
import 'package:providerapp/widgets/login_signin_tab.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock_open),
                  text: "Login",
                ),
              ],
            ),
            title: Text('Welcome'),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(child: LoginSigninTab()),
            ],
          ),
        ));
  }
}
