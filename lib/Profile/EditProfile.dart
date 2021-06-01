import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messager/Colors/ColorsEditProfile.dart';
import 'package:messager/Colors/ColorsOfProfile.dart';
import 'package:messager/Widget/ToastAlert.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

goBackToPreviousScreen(BuildContext context) {
  Navigator.pop(context);
}

var uid = FirebaseAuth.instance.currentUser.uid;

class _EditProfileState extends State<EditProfile> {
  TextEditingController _editingNameController;
  Uri imageUri;
  Uint8List uploadedImage;
  ValueNotifier<String> imageLink;

  @override
  void initState() {
    super.initState();
    imageLink = ValueNotifier<String>(" ");
    _editingNameController = TextEditingController(text: " ");
  }

  @override
  void dispose() {
    _editingNameController.dispose();
    imageLink.dispose();
    super.dispose();
  }

  void _updateUser() {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      "name": _editingNameController.text.toString(),
      "imageUri": imageLink.value.toString(),
    });
  }

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
          return showDialog(
              context: context,
              builder: (ctx) => ToastAlert(
                  title: "Sign In",
                  text: "some error occur",
                  context: context));
        });

        reader.readAsArrayBuffer(file);
      }
    });

    return imageUri;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(color: ColorsOfProfile.titleColor)),
        backgroundColor: ColorsOfProfile.appbarBackgroundColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid', isEqualTo: uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data.docs.map((document) {
                    _editingNameController =
                        TextEditingController(text: document['name']);
                    imageLink.value = document['imageUri'];
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 18.0),
                            child: ValueListenableBuilder(
                                valueListenable: imageLink,
                                builder: (context, value, widget) {
                                  return CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(imageLink.value),
                                    radius: 70,
                                  );
                                }),
                          ),
                          FloatingActionButton.extended(
                            onPressed: () {
                              _startFilePicker();
                            },
                            elevation: 0,
                            label: Text("Upload Image"),
                            backgroundColor: ColorsEditProfile.buttonColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Card(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(
                                    color: ColorsEditProfile.textColor,
                                  ),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.person,
                                      color: ColorsEditProfile.iconColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            ColorsEditProfile.textBorderColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            ColorsEditProfile.textBorderColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: ColorsOfProfile.textColor,
                                    fontSize: 30),
                                controller: _editingNameController,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Card(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email, size: 30),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    document['email'],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: ColorsOfProfile.textColor,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check_circle_outlined),
          backgroundColor: ColorsOfProfile.appbarBackgroundColor,
          onPressed: () {
            _updateUser();
            goBackToPreviousScreen(context);
          }),
    );
  }
}
