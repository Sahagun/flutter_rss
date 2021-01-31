import 'package:flutter/material.dart';

class Article extends StatelessWidget {

  String url;

  Article({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(url),
      ),
    );

  }
}