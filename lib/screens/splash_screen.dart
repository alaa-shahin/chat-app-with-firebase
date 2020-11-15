import 'package:chat_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Center(
            child: SplashScreen(
              backgroundColor: Colors.lightBlueAccent,
              image: Image.asset('assets/images/chat.png'),
              title: Text(
                'Chat App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              photoSize: 100,
              seconds: 2,
              loadingText: Text('Loading...'),
              loaderColor: Colors.yellow,
              navigateAfterSeconds: MyApp(),
            ),
          ),
        ),
      ),
    );
  }
}
