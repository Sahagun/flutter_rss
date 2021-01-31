import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'databasehelper.dart';
import 'global.dart';
import 'main.dart';

class AddRSSPage extends StatefulWidget {
  @override
  _AddRSSState createState() => _AddRSSState();
}

class _AddRSSState extends State<AddRSSPage>{
  final _formKey = GlobalKey<FormState>();
  String _url;

  bool validateURL(String _url){
    return Uri.parse(_url).isAbsolute;
  }

  void onButtonPress(_context){
    bool valid = validateURL(_url);

    Scaffold
        .of(_context)
        .showSnackBar(SnackBar(content: valid ? Text("added $_url") : Text("invalid url")));

    if (valid){
      Global().fbSaveURL(_url);
      // Navigator.of(_context).pop();
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => FrontPage()));

    }


    // Global().testDB();


    // DatabaseHelper.instance;
    // var d = DatabaseHelper.instance.queryGetURLs(Global().userID);
    // print( "Database: $d");
    // Global().saveURL(_url);
    // print("Test: $_context");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add RSS"),
        ),
        body:
        Builder(
          builder: (context) =>
            Center(
                child:Form(
                  key: _formKey,
                  child:

                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child:
                      Column(
                          children: <Widget>[
                            // URL
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'RSS URL',
                                labelText: 'RSS URL',
                              ),
                              onChanged: (String value){
                                _url = value;
                              },
                            ),

                            SizedBox(height: 50),
                            // Add Button
                            ElevatedButton(
                              onPressed: (){
                                // Scaffold
                                //     .of(context)
                                //     .showSnackBar(SnackBar(content: Text("Hello?")));
                                onButtonPress(context);

                              },
                              child: Text('Add RSS Feed'),
                            ),
                          ]
                      )
                  )
              ),
          ),
        )
    );
  }
}
