import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messager/Colors/ColorsOfProfile.dart';
import 'package:messager/Profile/EditProfile.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                  .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 18.0),
                            child: CircleAvatar(
                              maxRadius: 100,
                              backgroundImage:
                                  NetworkImage(document['imageUri']),
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
                                  Icon(Icons.person, size: 30),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    document['name'],
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
          child: Icon(Icons.mode_edit),
          backgroundColor: ColorsOfProfile.appbarBackgroundColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            );
          }),
    );
  }
}
