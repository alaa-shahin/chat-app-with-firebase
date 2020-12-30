import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SplashScreens());
}

class MyApp extends StatefulWidget {
  static const routeName = '/';
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chat_app',
      theme: ThemeData(
        primaryColor: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        AuthScreen.routeName: (ctx) => AuthScreen(),
        ChatScreen.routeName: (ctx) => ChatScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ChatScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
