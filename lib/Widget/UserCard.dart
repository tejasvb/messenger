import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messager/Colors/ColorHomePage.dart';

class UserCard extends StatefulWidget {
  final String uid;
  final String name;
  final String imageUri;

  UserCard({this.uid, this.name, this.imageUri});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext ct) {
    return Container(
      child: Column(
        children: [
          Divider(
            color: ColorHomePage.dividerColor,
            height: 20,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.imageUri),
                radius: 30,
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      color: ColorHomePage.nameColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('message')
                        .doc(currentUser.uid)
                        .collection(widget.uid)
                        .orderBy("DataAndTime", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          ".....................",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorHomePage.subtitleColor,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      } else {
                        if (snapshot.data.docs.isEmpty) {
                          return Text(
                            "Click To Message",
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorHomePage.subtitleColor,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        } else {
                          var t =
                              snapshot.data.docs.first['message'].toString();
                          if (t.length > 12) {
                            t = t.substring(0, 12) + "...";
                          }
                          return Text(
                            t,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorHomePage.subtitleColor,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
