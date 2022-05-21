import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      text: 'Flowers  Recognizer  App',
      backgroundColor: Colors.white,
      colors: const [
        Colors.black87,
      ],
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Colors.black87,
        fontFamily: "Signatra",
      ),
      navigateRoute: Home(),
      duration: 5,
      imageSrc: 'assets/flowers.png',
      imageSize: 180,
    );
  }
}
