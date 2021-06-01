import 'package:flutter/material.dart';
import "package:messager/Colors/ColorsInLoginAndRegistration.dart";
import 'package:messager/Widget/ToastAlert.dart';
import 'package:messager/Service/auth_service.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    String email;
    String password;
    _uploadUserToFirebase() {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if ((email != null) && (password != null)) {
        if (!regex.hasMatch(email)) {
          return showDialog(
              context: context,
              builder: (ctx) => ToastAlert(
                  title: "Sign In",
                  text: "Enter Valid Email",
                  context: context));
        } else {
          AuthService()
              .signIn(email: email, password: password)
              .then((_result) {
            if ("success" == _result) {
              Navigator.pop(context);
            } else {
              return showDialog(
                  context: context,
                  builder: (ctx) => ToastAlert(
                      title: "Sign In", text: _result, context: context));
            }
          });
        }
      } else {
        return showDialog(
            context: context,
            builder: (ctx) => ToastAlert(
                title: "Sign In",
                text: "please enter email or password",
                context: context));
      }
    }

    return Container(
      color: ColorsInLoginAndRegistration.background,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  color: ColorsInLoginAndRegistration.cardBackground,
                  child: TextField(
                    onChanged: (value) => email = value,
                    decoration: InputDecoration(
                      labelText: "Email",
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.email_outlined,
                          color: ColorsInLoginAndRegistration.iconColor,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: ColorsInLoginAndRegistration.text,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorsInLoginAndRegistration.focusBorderText,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorsInLoginAndRegistration.borderText,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Card(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  color: ColorsInLoginAndRegistration.cardBackground,
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) => password = value,
                    decoration: InputDecoration(
                      labelText: "Password",
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: ColorsInLoginAndRegistration.iconColor,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: ColorsInLoginAndRegistration.text,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorsInLoginAndRegistration.focusBorderText,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorsInLoginAndRegistration.borderText,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Card(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  color: ColorsInLoginAndRegistration.cardBackground,
                  child: FloatingActionButton.extended(
                    heroTag: "Login",
                    label: Text('Log in'),
                    icon: Icon(
                      Icons.assignment_turned_in_outlined,
                      color: ColorsInLoginAndRegistration.iconColor,
                    ),
                    backgroundColor: ColorsInLoginAndRegistration.buttonColor,
                    onPressed: () {
                      _uploadUserToFirebase();
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextButton(
                  child: Text(
                    "Don't have an account have an account",
                    style: TextStyle(
                      color: ColorsInLoginAndRegistration.text,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
