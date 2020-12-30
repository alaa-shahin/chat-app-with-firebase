import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String _newUserName;
  static String _newAge = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserService().fetchCurrentUserData(currentUser.email),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Your Profile'),
                  actions: <Widget>[
                    DropdownButton(
                      underline: Container(),
                      icon: Icon(Icons.more_vert,
                          color: Theme.of(context).primaryIconTheme.color),
                      items: [
                        DropdownMenuItem(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                          value: 'logout',
                        ),
                      ],
                      onChanged: (item) {
                        if (item == 'logout') {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushNamed(AuthScreen.routeName);
                        }
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Text(
                    "Sorry, Something went wrong!\n But We're working on it.\n\nIf the issue still persists please contact us at alaashahin743@gmail.com\n\nGo to logout then Try to sign up first",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                backgroundColor: Colors.white);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Your Profile'),
                  actions: <Widget>[
                    DropdownButton(
                      underline: Container(),
                      icon: Icon(Icons.more_vert,
                          color: Theme.of(context).primaryIconTheme.color),
                      items: [
                        DropdownMenuItem(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                          value: 'logout',
                        ),
                      ],
                      onChanged: (item) {
                        if (item == 'logout') {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushNamed(AuthScreen.routeName);
                        }
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data['profileImage']),
                              maxRadius: 50,
                              backgroundColor: Colors.lightGreen[500],
                            ),
                            Text(
                              'Profile Photo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty || val.length < 3) {
                                  return 'Please enter at least 3 characters';
                                }
                                return null;
                              },
                              autocorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              key: ValueKey('User name:'),
                              decoration:
                                  InputDecoration(labelText: 'User name'),
                              keyboardType: TextInputType.text,
                              initialValue: snapshot.data['userName'],
                              onSaved: (val) => _newUserName = val,
                            ),
                            SizedBox(height: 10),
                            FocusScope(
                              node: new FocusScopeNode(),
                              child: TextFormField(
                                key: ValueKey('Email:'),
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    fillColor: Colors.grey,
                                    filled: true),
                                initialValue: snapshot.data['email'],
                                readOnly: true,
                                enabled: false,
                                enableInteractiveSelection: false,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty ||
                                    !(int.parse(val) <= 120 &&
                                        int.parse(val) > 0)) {
                                  return 'Please enter your Age from 1 to 120';
                                }
                                return null;
                              },
                              autocorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              key: ValueKey('Age:'),
                              decoration: InputDecoration(labelText: 'Age'),
                              keyboardType: TextInputType.number,
                              initialValue: snapshot.data['age'],
                              onSaved: (val) {
                                _newAge = val;
                              },
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                            ),
                            SizedBox(height: 30),
                            Container(
                              height: 60.0,
                              width: 300.0,
                              padding: const EdgeInsets.all(10.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    FocusScope.of(context).unfocus();

                                    _formKey.currentState.save();

                                    dynamic result = await UserService()
                                        .updateUserData(
                                            _newUserName,
                                            _newAge,
                                            snapshot.data['userName'],
                                            snapshot.data['age'],
                                            currentUser.uid,
                                            snapshot.data['profileImage'],
                                            snapshot.data['email']);
                                    if (null == result) {
                                      Flushbar(
                                        title: "Yaaay",
                                        message: "Successfully Saved!",
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    } else {
                                      Flushbar(
                                        title: "Sorry",
                                        message: "Something went wrong!",
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    }
                                  } else {
                                    Flushbar(
                                      title: "Sorry",
                                      message: "Please enter valid data!",
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.white,
            );
          }
        });
  }
}
