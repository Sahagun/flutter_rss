import 'package:flutter/material.dart';

import 'global.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
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

  String _password = '';
  String _email = '';

  FutureBuilder _loginButton(String _email, String _password){
    print('login: a');
    Future<String> result = Global().login(_email, _password);

    return FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('login: You have an error! ${snapshot.error.toString()}');
            return Text(snapshot.data);
          }
          else if (snapshot.hasData) {
            print('Has Data');
            //return LoginForm();
            // test();
            print('login: You have an error with data!');
            return Text(snapshot.data);
          }
          else {
            print('loading');
            return Text("loading");
          }
        }
    );
  }

  FutureBuilder _registerButton(String _email, String _password){
    Future<String> result = Global().register(_email, _password);
    return FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('You have an error! ${snapshot.error.toString()}');
            return Text(snapshot.data);
          }
          else if (snapshot.hasData) {
            print('Has Data');
            //return LoginForm();
            // test();
            return Text(snapshot.data);
          }
          else {
            print('loading');
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
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                Scaffold
                                    .of(context)
                                    .showSnackBar(SnackBar(content: _registerButton(_email,_password) ));
                              }
                            },
                            child: Text('Register'),
                          ),

                          // Login
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.

                                Scaffold
                                    .of(context)
                                    .showSnackBar(SnackBar(content: _loginButton(_email,_password)));
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

