import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/Auth_form.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String userName,
    String age,
    String profileImage,
    bool isLogin,
    bool isGoogleLogin,
    BuildContext ctx,
  ) async {
    UserCredential userResult;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        userResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      } else {
        userResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        var res = await AuthService().createUserDocument(userResult.user.uid, {
          'userName': userName,
          'email': email,
          'age': age,
          'profileImage': profileImage,
        });
        Navigator.of(context).pushNamed(ChatScreen.routeName);

        if (null == res) {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text('Successfully registered'),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
          Flushbar(
            title: "Success",
            message: "You are registered successfully!",
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          )..show(ctx);
        } else {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text('Something went wrong, please try again later'),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
          Flushbar(
            title: "Sorry",
            message: "Something went wrong!\n Please try again later :(",
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          )..show(ctx);
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Error Occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user';
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('app crashed'),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading, AuthService().googleSignup),
    );
  }
}
