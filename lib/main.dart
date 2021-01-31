import 'dart:async';
// import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';


import 'AddRSSFeed.dart';
import 'RSSListView.dart';
import 'global.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  Future<void> test() async {
    await Global().fbLoadRSS();

    // print("JS: is logged in " + Global().isLoggedIn.toString());

    // print("JS: registered " + (await Global().register("js@example.com", "SuperSecretPassword")).toString());
    // print("JS: login " + (await Global().login("js@example.com", "SuperSecretPassword")).toString());

    // print("JS: is logged in " + Global().isLoggedIn.toString());
    // var o = Global().logout();
    // print("JS: is logged in " + Global().isLoggedIn.toString());

  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot){
          if(snapshot.hasError){
            // print('You have an error! ${snapshot.error.toString()}');
            return Text('Error');
          }
          else if (snapshot.hasData){
            // print('Has Data');
            //return LoginForm();
            // test();

            // If logged in go to Front Page Else Login Page
            FirebaseAuth auth = FirebaseAuth.instance;
            if (auth.currentUser != null) {
              Global().userID = auth.currentUser.uid;
              return FrontPage();
            }
            else {
              return MyHomePage(title: 'The CodingMinds Times');
            }
          }
          else{
            // print('loading');
            return Center(
                child: CircularProgressIndicator(),
            );
          }
        }
      )

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _register() {
    setState(() async {
      try {
        // print("JS: try register");
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: "barry.allen@example.com",
            password: "SuperSecretPassword!"
        );
        // print('JS: ' + userCredential.user.toString());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          // print('The account already exists for that email.');
        }
      } catch (e) {
        // print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginForm(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Global().fbLoadRSS();
        },
        child: Text("Test"),
      ),

    );
  }
}






// Where all the articles are gathered
class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage>{
  FirebaseAuth auth = FirebaseAuth.instance;

  FutureOr refresh(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Stand"),
      ),
      body: Center(
          child:
            Column(
              children: <Widget>[
                // Global().userStatusText(),
                Expanded(
                  child:RssListView(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push (
                          context,
                          // MaterialPageRoute(builder: (context) => AddRSSPage()),).then(refresh);
                          MaterialPageRoute(builder: (context) => AddRSSPage()),);
                      },
                      child: Text('Add Rss'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Global().restartDatabase();
                        Global().fbClearUserRSS();
                        Global().logout();
                        refresh(null);
                        // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => MyHomePage(title: 'The Shayna Times')));
                      },
                      child: Text('Clear Rss'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Global().logout();
                        // print('try log out');
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => MyHomePage(title: 'The CodingMinds Times')));
                      },
                      child: Text("Logout"),
                    ),

                  ],
                )

              ]

            ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Global().logout();
      //     print('try log out');
      //     Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => MyHomePage(title: 'The Shayna Times')));
      //   },
      //   child: Text("Logout"),
      // ),

    );
  }
}