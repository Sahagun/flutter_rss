import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rss/databasehelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class Global{
  static final Global _global = Global._internal();

  int id = -1;
  UserCredential userCredential;
  String userID = null;

  final FirebaseDatabase referenceDatabase = FirebaseDatabase.instance;

  // bool isLoggedIn = false;

  factory Global() {
    return _global;
  }

  Future<String> register(String _email, String _password) async {
      String result = 'Unknown Error.';
      try {
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email,
            password: _password
        );
        userID = userCredential.user.uid;
        // isLoggedIn = true;
        result = "Success.";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          result = "Error: register error The password provided is too weak.";
          print('Error: register error The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          result = "Error: register error The account already exists for that email.";
          print('Error: register error The account already exists for that email.');
        }
        else{
          result = "Unknown Error.";
          print('Error: register error else');
          print('Error: $e.code');
        }
      } catch (e) {
        result = "Unknown Error.";
        print('Error: register error else $e');
      }
      return result;
  }

  Future<String> login(String _email, String _password) async {
    String result = "Unknown Error.";
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password
      );
      userID = userCredential.user.uid;
      result = 'Successful Login.';
      // isLoggedIn = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = 'No user found for that email.';
        print('Login: No user found for that email.');
      } else if (e.code == 'wrong-password') {
        result = 'Wrong password provided for that user.';
        print('Login: Wrong password provided for that user.');
      }
      else{
        print('login: else else');

      }
    }
    return result;
  }

  bool logout(){
    // isLoggedIn = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    return true;
  }


  bool isLoggedin(){
    FirebaseAuth auth = FirebaseAuth.instance;
    return (auth.currentUser != null);
    }

  String userStatus(){
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return auth.currentUser.uid;
    }
    return "Not Logged In.";
  }

  Text userStatusText(){
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return Text(auth.currentUser.uid);
    }
    return Text("Not Logged In.");
  }


  Future<List<String>> loadRSS() async{
    print("loadRSS: start fucntion");

    print("loadRSS:  helper");

    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.initDatabase();
    print("loadRSS:  list");

    // List<Map> list = await helper.getRSSList("userid1");
    List<Map> list = await helper.getRSSList(userID);

    print("loadRSS: null $list");

    List<String> returnList = List();

    if (list != null) {
      for (var l in list) {
        String s = l["url"];
        print("loadRSS: $s");
        returnList.add(s);
      }
      print("loadRSS: end fucntion");
    }
    return returnList;
  }

  void restartDatabase() async{
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.initDatabase();
    helper.restartDatabase();
  }

  void saveURL(String _url) async{
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.initDatabase();
    RSS rss = RSS(_url, userID);
    rss = await helper.insertRSS(rss);

    // loadRSS();

    // print("Save: start");
    // RSS rss = RSS(_url, "userID");
    // var rssMap = rss.toMap();
    // DatabaseHelper helper = DatabaseHelper.instance;
    // print('Save: rss $rssMap');
    // int id = await helper.insert(rss);
    // print('Save: after');
    // print('Save: inserted row $id, $rss');
  }

  Future<XmlDocument> loadXML(String url) async{
    String raw = await http.read(url);
    print(raw.length);
    // final XmlDocument document =  XmlDocument.parse(raw);
    // // print("Pre return");

    return XmlDocument.parse(raw);;
  }

  void testDB() async{
    print("testDB: start");

    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.initDatabase();

    helper.status();

    RSS rss = RSS('google.com','userid1');

    rss = await helper.insertRSS(rss);

    print("testDB: rss " + rss.id.toString());

    List<Map> list = await helper.getRSSList('userid1');

    print("testDB: $list");

    // RSS rss = RSS("google.com", "user1");
    // print("JS TEST: a");
    // helper.insert(rss);
  }




  void fbClearUserRSS() async{
    // Deletes all entries
    final DatabaseReference rssRef = referenceDatabase.reference().child('RSS');
    rssRef.child(userID).remove();
  }

  Future<List<String>> fbLoadRSS() async{
    print("RssListView fbLoadRSS");

    final DatabaseReference rssRef = referenceDatabase.reference().child('RSS');

    List<String> urlList = List();

    await rssRef.child(userID).once().then(
        (DataSnapshot snapshot){
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key,values) {
            urlList.add(values.toString());
          });
        }
    );
    return urlList;
  }

  void fbSaveURL(String _url) async{
    final DatabaseReference ref = referenceDatabase.reference();
    await ref.child('RSS').child(userID).push().set(_url);

    // DatabaseHelper helper = DatabaseHelper.instance;
    // await helper.initDatabase();
    // RSS rss = RSS(_url, userID);
    // rss = await helper.insertRSS(rss);
  }


  Global._internal();
}
