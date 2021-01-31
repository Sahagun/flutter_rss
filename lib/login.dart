import 'package:flutter/material.dart';

import 'global.dart';
import 'main.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    print("Test Login " + Global().isLoggedin().toString());
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String _password = 'SuperSecretPassword';
  String _email = 'js@example.com';

  String _status = 'not logged in';

  void _updateStatus(){
    setState(() {
      _status = Global().userStatus();
    });

  }

  FutureBuilder _loginButtonStatus(String _email, String _password){
    Future<String> result = Global().login(_email, _password);

    return FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // print('login: You have an error! ${snapshot.error.toString()}');
            return Text(snapshot.data);
          }
          else if (snapshot.hasData) {
            // print('login: Has Data');
            // if (Global().isLoggedin()){
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => FrontPage())
            //   );
            // }
            return Text(snapshot.data);
          }
          else {
            // print('loading');
            return Text("loading");
          }
        }
    );
  }

  FutureBuilder _registerButtonStatus(String _email, String _password){
    Future<String> result = Global().register(_email, _password);
    return FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // print('You have an error! ${snapshot.error.toString()}');
            return Text(snapshot.data);
          }
          else if (snapshot.hasData) {
            // print('Has Data');
            //return LoginForm();
            // test();
            return Text(snapshot.data);
          }
          else {
            // print('loading');
            return Text("loading");
          }
        }
    );
  }

  void _toggleObscureText(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child:

        Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Column(
                    children: <Widget>[
                      // EMAIL
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email *',
                        ),
                        initialValue: "js@example.com",
                        onChanged: (String value){
                          _email = value;
                        },
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return value.contains('!') ? 'Do not use the ! char.' : null;
                        },
                      ),


                      Row(
                          children: <Widget>[
                            Flexible(child:
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Password',
                                  labelText: 'Password *',
                                ),
                                initialValue: "SuperSecretPassword",
                                obscureText: _obscureText,
                                onChanged: (String value){
                                  _password = value;
                                },
                                onSaved: (String value) {
                                  // This optional block of code can be used to run
                                  // code when the user saves the form.
                                },
                                validator: (String value) {
                                  return value.contains('@') ? 'Do not use the @ char.' : null;
                                },
                              ),
                            ),
                            new FlatButton(
                                onPressed: _toggleObscureText,
                                child: new Text(_obscureText ? "Show" : "Hide")
                            ),

                          ]
                      ),

                      SizedBox(height: 50),


                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // REgister
                            ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                FutureBuilder futureBuild =  _registerButtonStatus(_email,_password);
                                Scaffold
                                    .of(context)
                                    .showSnackBar(SnackBar(content: futureBuild ));
                                      futureBuild.future.then((value) {
                                        if (Global().isLoggedin()){
                                          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => FrontPage()));
                                        }
                                    });


                              }
                            },
                            child: Text('Register'),
                          ),

                          // Login
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                FutureBuilder futureBuild =  _loginButtonStatus(_email,_password);
                                Scaffold
                                    .of(context)
                                    .showSnackBar(SnackBar(content: futureBuild));

                                // Call back when done logging in or not
                                futureBuild.future.then((value) {
                                  if (Global().isLoggedin()){
                                    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => FrontPage()));
                                  }
                                });
                              }
                            },
                            child: Text('Login'),
                          ),
                      ]
                      )
            ]
          )
        )
    );
  }
}

