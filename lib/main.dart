import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messager/SplashScreen/SplashScreenMessager.dart';

//image view only works in chrome
//flutter run -d chrome --web-renderer html
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenMessager(),
    );
  }
}
