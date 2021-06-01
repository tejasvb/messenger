import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messager/Colors/ColorHomePage.dart';
import 'package:messager/Home/ChatPage.dart';
import 'package:messager/Profile/Profile.dart';
import 'package:messager/Service/auth_service.dart';
import 'package:messager/Widget/UserCard.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var currentUser = FirebaseAuth.instance.currentUser;

class _HomePageState extends State<HomePage> {
  ValueNotifier<String> searchText;

  @override
  void initState() {
    searchText = ValueNotifier<String>("  ");

    super.initState();
  }

  @override
  void dispose() {
    searchText.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHomePage.backgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("images/IconMessager.jpg"),
        ),
        title: Text("Messenger",
            style: TextStyle(color: ColorHomePage.titleColor)),
        backgroundColor: ColorHomePage.appBarBackgroundColor,
        actions: <Widget>[
          Container(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
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
                  } else {
                    var document = snapshot.data.docs.first;
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: NetworkImage(document['imageUri']),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'LogOut',
            onPressed: () async {
              await AuthService().signOut().then(
                    (value) => Navigator.pop(context),
                  );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorHomePage.searchViewColor,
              border: Border.all(
                  color: ColorHomePage.searchViewBorderColor, width: 2.0),
              borderRadius: BorderRadius.circular(80.0),
            ),
            child: SizedBox(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 5, right: 20),
                child: TextField(
                  cursorColor: ColorHomePage.searchViewCursorColor,
                  style: TextStyle(color: ColorHomePage.searchViewTextColor),
                  onChanged: (text) => {
                    setState(() => {
                          searchText.value = text.toString(),
                        })
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: ColorHomePage.searchViewFillColor,
                    hintText: " Search By Name",
                    hintStyle: TextStyle(
                      color: ColorHomePage.searchViewHintColor,
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.search_outlined,
                        color: ColorHomePage.searchViewLabelColor,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: ColorHomePage.searchViewLabelColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          ValueListenableBuilder(
              valueListenable: searchText,
              builder: (context, value, widget) {
                if (value.toString().trim().isNotEmpty) {
                  return Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('name',
                              isGreaterThanOrEqualTo: value.toString())
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
                            if (document['uid'] != currentUser.uid) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          uid: document['uid'],
                                          imageUri: document['imageUri'],
                                          name: document['name']),
                                    ),
                                  );
                                },
                                child: listTileForUser(
                                    uid: document['uid'],
                                    imageUri: document['imageUri'],
                                    name: document['name']),
                              );
                            } else {
                              return SizedBox(
                                height: 1,
                              );
                            }
                          }).toList(),
                        );
                      },
                    ),
                  );
                } else {
                  return Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
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
                            if (document['uid'] != currentUser.uid) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          uid: document['uid'],
                                          imageUri: document['imageUri'],
                                          name: document['name']),
                                    ),
                                  );
                                },
                                child: UserCard(
                                    uid: document['uid'],
                                    imageUri: document['imageUri'],
                                    name: document['name']),
                              );
                            } else {
                              return SizedBox(
                                height: 1,
                              );
                            }
                          }).toList(),
                        );
                      },
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}

Widget listTileForUser({String uid, String imageUri, String name}) {
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
              backgroundImage: NetworkImage(imageUri),
              radius: 30,
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
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
                      .collection(uid)
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
                        var t = snapshot.data.docs.first['message'].toString();
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
