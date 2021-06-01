import 'package:flutter/material.dart';

class ToastAlert extends StatelessWidget {
  ToastAlert({this.title, this.text, this.context});

  final BuildContext context;
  final String title;
  final String text;

  @override
  Widget build(BuildContext ct) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("okay"),
        ),
      ],
    );
  }
}
