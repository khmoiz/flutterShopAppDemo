import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerapp/models/auth_status.dart';
import 'package:providerapp/models/user.dart';
import 'package:providerapp/providers/auth_provider.dart';
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
  bool _isInit = true;
  User _currentUser = new User.emptyUser();

  var _initValues = {
    'id': 'no user',
    'email': 'no email',
    'nickName': 'no name',
    'phoneNumber': 'no number',
  };

  @override
  void initState() {
    super.initState();
    if (_isInit) {
      var _authProvider = Provider.of<AuthProvider>(context, listen: false);
      _authProvider.demoVerifyPhone(context);
      if (_authProvider.status == AuthStatus.Authenticated) {
        if (_authProvider.user != null || _authProvider.user.id != null) {
          setState(() {
            _currentUser = _authProvider.user;
            print(_currentUser.toString());
            _initValues = {
              'id': _currentUser.id,
              'email': (_currentUser.email == "")
                  ? "no email sign in setup"
                  : _currentUser.email,
              'nickName': _currentUser.nickName,
              'phoneNumber': _currentUser.phoneNumber,
            };
          });
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var _authProvider = Provider.of<AuthProvider>(context, listen: false);
//      _authProvider.demoVerifyPhone(context);
      if (_authProvider.status == AuthStatus.Authenticated) {
        setState(() {
          _currentUser = _authProvider.user;
          print(_currentUser.toString());
          _initValues = {
            'id': _currentUser.id,
            'email': _currentUser.email,
            'nickName': _currentUser.nickName,
            'phoneNumber': _currentUser.phoneNumber,
          };
        });
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> showUserData() async {
    if (_isInit) {
      var _authProvider = Provider.of<AuthProvider>(context);
      var wait = await _authProvider.demoVerifyPhone(context);
      if (_authProvider.status == AuthStatus.Authenticated) {
        setState(() {
          _currentUser = _authProvider.user;
          print(_currentUser.toString());
          _initValues = {
            'id': _currentUser.id,
            'email': _currentUser.email,
            'nickName': _currentUser.nickName,
            'phoneNumber': _currentUser.phoneNumber,
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        drawer: AppDrawer(),
        body: bodyContent(context));
  }

  bodyContent(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Sign in Phone (4167224564)'),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .demoVerifyPhone(context)
                    .then((_) => showUserData());
              },
            ),
            Text('${_currentUser.toString()}'),
            SizedBox(
              height: 10,
            ),
            Text('Welcome User'),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.00)),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Text('User ID : '),
                    Text(' ${_currentUser.id}'),
                  ],
                )),
            OutlineButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.00)),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Text('Email : '),
                    Text(' ${_currentUser.email}'),
                  ],
                )),
            OutlineButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.00)),
                color: Theme.of(context).primaryColor,
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Text('NickName : '),
                    Text(' ${_currentUser.nickName}'),
                  ],
                )),
            OutlineButton(
                color: Theme.of(context).primaryColor,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.00)),
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Text('PhoneNumber : '),
                    Text(' ${_currentUser.phoneNumber}'),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            Text('Setup Account ? '),
            RaisedButton(
              child: Text('Update Details'),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text('Link Email'),
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

/*

TextFormField(
initialValue: _initValues['email'],
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
initialValue: _initValues['nickName'],
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
initialValue: _initValues['phoneNumber'],
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
)*/
