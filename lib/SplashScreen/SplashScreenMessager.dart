import 'package:flutter/material.dart';
import 'package:messager/RegistrationAndLogin/RegistrationScreen.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenMessager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: RegistrationScreen(),
      title: Text(
        'Messager-Web',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset("images/IconMessager.jpg"),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.green,
      backgroundColor: Colors.greenAccent,
    );
  }
}
