import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class AuthForm extends StatefulWidget {
  static const routeName = '/AuthForm';
  final void Function(
    String email,
    String password,
    String userName,
    String age,
    String profileImage,
    bool isLogin,
    bool isGoogleLogin,
    BuildContext ctx,
  ) submitFn;
  final void Function() signupWithGoogle;
  final bool _isLoading;

  AuthForm(this.submitFn, this._isLoading, this.signupWithGoogle);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final fromKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isGoogleLogin = false;
  static String _email = '';
  String _password = '';
  String _userName = '';
  String _age = '';
  static String _profileImage = '';

  bool isURLValid = isURL(_profileImage);

  bool validateURL(String value) {
    Pattern pattern =
        r'^(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?';
    RegExp regex = new RegExp(pattern, caseSensitive: false);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern, caseSensitive: false);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Future<void> submit() async {
    final isValid = fromKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      fromKey.currentState.save();
      widget.submitFn(_email.trim(), _password.trim(), _userName.trim(), _age,
          _profileImage, _isLogin, _isGoogleLogin, context);
    }
  }

  Future<void> googleSignup() async {
    FocusScope.of(context).unfocus();
    widget.signupWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Form(
              key: fromKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('username'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 3) {
                          return 'Please enter at least 3 characters';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'User name'),
                      onSaved: (val) => _userName = val,
                    ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('age'),
                      validator: (val) {
                        if (val.isEmpty ||
                            !(int.parse(val) <= 120 && int.parse(val) > 0)) {
                          return 'Please enter your Age from 1 to 120';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Age'),
                      onSaved: (val) => _age = val,
                    ),
                  TextFormField(
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey('Email'),
                    validator: (val) {
                      if (val.isEmpty || !validateEmail(val)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (val) => _email = val,
                  ),
                  TextFormField(
                    key: ValueKey('Password'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'Please enter a least 7 characters';
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('Profile Image'),
                      validator: (val) {
                        if (val.isEmpty || !validateURL(val)) {
                          return 'Please enter a valid URL for an image';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.url,
                      decoration:
                          InputDecoration(labelText: 'Profile Image Link'),
                      onSaved: (val) => _profileImage = val,
                    ),
                  SizedBox(height: 20),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      onPressed: () {
                        submit();
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  if (_isLogin)
                    Text(
                      'Or',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  if (_isLogin)
                    RaisedButton(
                      color: Colors.white,
                      textColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/google_logo.png'),
                            height: 35.0,
                          ),
                          Padding(padding: const EdgeInsets.only(left: 10)),
                          Text("Signin with Google"),
                        ],
                      ),
                      onPressed: () async {
                        await AuthService().googleSignup();
                        Navigator.of(context).pushNamed(ChatScreen.routeName);
                      },
                    ),
                  if (!widget._isLoading)
                    FlatButton(
                      textColor: Colors.blue,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
