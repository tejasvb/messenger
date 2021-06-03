import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messager/Colors/ColorChatPage.dart';

class MessageBorder {
  sendData() {
    return BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20));
  }

  receivedData() {
    return BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20));
  }
}



class ChatPage extends StatefulWidget {
  ChatPage({this.imageUri, this.name, this.uid});

  final String imageUri;
  final String name;
  final String uid;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final message = TextEditingController();


  @override
  Widget build(BuildContext context) {
    bool boolean = false;
    String currentDate = " ";
    void uploadData({String message}) {
      if (message.trim().toString().isNotEmpty) {
        message = message.trimLeft();
        message = message.trimRight();
        FirebaseFirestore.instance
            .collection('message')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(widget.uid)
            .add({
              "message": message.toString(),
              "From": FirebaseAuth.instance.currentUser.uid,
              "To": widget.uid,
              "DataAndTime": DateTime.now()
            })
            .then((value) => print("send message"))
            .catchError((error) => print("Failed to add user: $error"));

        FirebaseFirestore.instance
            .collection('message')
            .doc(widget.uid)
            .collection(FirebaseAuth.instance.currentUser.uid)
            .add({
              "message": message.toString(),
              "From": FirebaseAuth.instance.currentUser.uid,
              "To": widget.uid,
              "DataAndTime": DateTime.now()
            })
            .then((value) => print("send message"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.imageUri),
            radius: 30,
          ),
        ),
        backwardsCompatibility: true,
        title: Text(widget.name, style: TextStyle(color: ColorChatPage.titleColor)),
        backgroundColor: ColorChatPage.backgroundAppbarColor,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('message')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection(widget.uid)
                    .orderBy("DataAndTime", descending: false)
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
                      Pattern patternDate = '[0-9]{4}-[0-9]{2}-[0-9]{2}';
                      RegExp regexDate = new RegExp(patternDate);
                      var dateAndTime = document['DataAndTime'].toDate();
                      var date =
                          regexDate.firstMatch(dateAndTime.toString()).group(0);
                      Pattern patternTime =
                          '[0-9]{1}[0-9]{1}:[0-9]{1}[0-9]{1}:[0-9]{1}[0-9]{1}';
                      RegExp regexTime = new RegExp(patternTime);

                      var time =
                          regexTime.firstMatch(dateAndTime.toString()).group(0);
                      if (date != currentDate) {
                        currentDate = date;
                        boolean = true;
                      } else {
                        boolean = false;
                      }
                      return Column(
                        children: [
                          if (boolean)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: ColorChatPage.dateColor,
                                ),
                                padding: EdgeInsets.only(
                                    left: 7, right: 7, top: 10, bottom: 10),
                                child: Text(date.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorChatPage.dateTextColor,
                                        backgroundColor: ColorChatPage
                                            .dateTextBackgroundColor)),
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment: (document['From'].toString() !=
                                      FirebaseAuth.instance.currentUser.uid
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: (document['From'].toString() !=
                                          FirebaseAuth.instance.currentUser.uid
                                      ? MessageBorder().sendData()
                                      : MessageBorder().receivedData()),
                                  color: (document['From'].toString() !=
                                          FirebaseAuth.instance.currentUser.uid
                                      ? ColorChatPage
                                          .receivedTextBackgroundColor
                                      : ColorChatPage.sendTextBackgroundColor),
                                ),
                                padding: EdgeInsets.only(
                                    left: 7, right: 7, top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth: 0.0,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4),
                                      child: Text(
                                        document['message'].toString(),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth: 0.0,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10),
                                      child: Align(
                                          alignment: (document['From'].toString() !=
                                            FirebaseAuth.instance.currentUser.uid
                                            ? Alignment.bottomLeft
                                            : Alignment.bottomRight),
                                        child: Text(
                                          "$time",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color:
                                                  ColorChatPage.timeTextColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    reverse:true,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: ColorChatPage.bottomColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: message,
                          decoration: InputDecoration(
                            hintText: "Enter a message..",
                            hintStyle: TextStyle(
                              color: ColorChatPage.messageTextFieldColor,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorChatPage.messageBorderColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorChatPage.messageBorderColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 16.0, bottom: 10),
                    child: CircleAvatar(
                      backgroundColor: ColorChatPage.messageSendButtonColor,
                      child: IconButton(
                          onPressed: () {
                            uploadData(message: message.text);
                            message.clear();
                          },
                          icon: Icon(Icons.send_rounded),
                          color: ColorChatPage.messageSendButtonIconColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
