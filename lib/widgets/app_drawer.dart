import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/models/user.dart';
import 'package:providerapp/providers/auth_provider.dart';
import 'package:providerapp/screens/login_screen.dart';
import 'package:providerapp/screens/order_screen.dart';
import 'package:providerapp/screens/user_favourite_products_screen.dart';
import 'package:providerapp/screens/user_products_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  User userData = new User.emptyUser();

  @override
  void initState() {
    super.initState();
    userData = Provider.of<AuthProvider>(context, listen: false).user;
    if (userData == null) {
      userData =
          new User.emptyUser(nickName: "User was null", email: "User was null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello ${userData.nickName}!'),
            automaticallyImplyLeading: false,
//            leading: CircleAvatar(
//              backgroundImage: NetworkImage(imageUrl))
          ),
          DrawerHeader(
            child: userData != null
                ? Column(
                    children: <Widget>[
                      Text("Email : ${userData.email}"),
                      Text("Phone Number : ${userData.phoneNumber}"),
                      Text("Account Type : ${userData.type}"),
                      Text("Document ID: ${userData.id}"),
                    ],
                  )
                : Text('No User | User was null'),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Master Products List'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Manage My Favourite Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserFavouriteProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false)
                  .signOutUser(context)
                  .then((_) {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              });
            },
          ),
        ],
      ),
    );
  }
}
