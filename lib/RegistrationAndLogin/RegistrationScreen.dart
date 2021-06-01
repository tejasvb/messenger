import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messager/Colors/ColorsInLoginAndRegistration.dart';
import 'package:messager/Home/HomePage.dart';
import 'package:messager/RegistrationAndLogin/LogIn.dart';
import 'package:messager/RegistrationAndLogin/SignUp.dart';

User user = FirebaseAuth.instance.currentUser;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      Future.delayed(const Duration(milliseconds: 0), () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        setState(
          () => user = FirebaseAuth.instance.currentUser,
        );
      });
      return HomePage();
    } else {
      print("registration");
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/IconMessager.jpg"),
          ),
          title: Text("Messenger",
              style: TextStyle(color: ColorsInLoginAndRegistration.titleColor)),
          backgroundColor: ColorsInLoginAndRegistration.appBarBackgroundColor,
        ),
        body: Container(
          color: ColorsInLoginAndRegistration.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FloatingActionButton.extended(
                  heroTag: "SignIn",
                  label: Text('Sign in '),
                  icon: Icon(Icons.add_to_home_screen_outlined),
                  backgroundColor: ColorsInLoginAndRegistration.buttonColor,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );

                    setState(
                      () => user = FirebaseAuth.instance.currentUser,
                    );
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                FloatingActionButton.extended(
                  heroTag: "LogIn",
                  label: Text('Log in '),
                  icon: Icon(Icons.person_pin),
                  backgroundColor:
                      ColorsInLoginAndRegistration.logInBackgroundColor,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                    setState(
                      () => user = FirebaseAuth.instance.currentUser,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
