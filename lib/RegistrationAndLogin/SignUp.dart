// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import "package:messager/Colors/ColorsInLoginAndRegistration.dart";
import 'package:messager/Widget/ToastAlert.dart';
import 'package:messager/Service/auth_service.dart';
import 'package:firebase/firebase.dart' as fb;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Uri imageUri;
  ValueNotifier<String> imageLink;

  @override
  void initState() {
    imageLink = ValueNotifier<String>(
        "https://img.icons8.com/color/1600/person-male.png");
    super.initState();
  }

  @override
  void dispose() {
    imageLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name;
    String email;
    String password;
    String confirmPassword;
    Uint8List uploadedImage;

    Future<Uri> uploadImageFile(Uint8List image) async {
      final metadata = fb.UploadMetadata(
        contentType: 'image/jpeg',
      );
      fb.StorageReference storageRef = fb.storage().ref("images/profile");
      final String fileName = Uuid().v1();
      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await storageRef.child(fileName).put(image, metadata).future;
      imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      imageLink.value = imageUri.toString();
      return imageUri;
    }

    Future<Uri> _startFilePicker() async {
      InputElement uploadInput = FileUploadInputElement();
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        // read file content as dataURL
        final files = uploadInput.files;
        if (files.length == 1) {
          final file = files[0];
          FileReader reader = FileReader();

          reader.onLoadEnd.listen((e) async {
            uploadedImage = reader.result;
            imageUri = await uploadImageFile(uploadedImage);
          });

          reader.onError.listen((fileEvent) {
            ToastAlert(title: "sign up", text: "some error occur");
          });

          reader.readAsArrayBuffer(file);
        }
      });

      return imageUri;
    }

    _uploadUserToFirebase() {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);

      if ((name != null) &&
          (email != null) &&
          (password != null) &&
          (imageUri != null) &&
          (confirmPassword != null)) {
        if (!regex.hasMatch(email)) {
          return showDialog(
              context: context,
              builder: (ctx) => ToastAlert(
                  title: "Sign In",
                  text: "password enter a valid email",
                  context: context));
        } else {
          if (password != confirmPassword) {
            return showDialog(
                context: context,
                builder: (ctx) => ToastAlert(
                    title: "Sign In",
                    text: "password and confirm password are not equal",
                    context: context));
          } else {
            AuthService()
                .signUp(
                    name: name,
                    email: email,
                    password: password,
                    imageUri: imageUri)
                .then((_result) {
              if ("Signed Up" == _result) {
                Navigator.pop(context);
              } else {
                return showDialog(
                    context: context,
                    builder: (ctx) => ToastAlert(
                        title: "Sign In", text: _result, context: context));
              }
            });
          }
        }
      } else {
        return showDialog(
            context: context,
            builder: (ctx) => ToastAlert(
                title: "Sign In",
                text: "please enter email or password or name or profile",
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
            ValueListenableBuilder(
                valueListenable: imageLink,
                builder: (context, value, widget) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(imageLink.value),
                    radius: 70,
                  );
                }),
            SizedBox(
              height: 30.0,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                _startFilePicker();
              },
              elevation: 0,
              label: Text("Upload Image"),
              backgroundColor: ColorsInLoginAndRegistration.buttonColor,
            ),
            SizedBox(
              height: 30.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  color: ColorsInLoginAndRegistration.cardBackground,
                  child: TextField(
                    onChanged: (value) => name = value,
                    decoration: InputDecoration(
                      labelText: "Name",
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.person_outline_rounded,
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
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) => confirmPassword = value,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
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
                    heroTag: "SignIn",
                    label: Text('Sign in'),
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
                    "Already have an account",
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
