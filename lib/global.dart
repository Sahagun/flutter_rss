import 'package:firebase_auth/firebase_auth.dart';

class Global{
  static final Global _global = Global._internal();

  int id = -1;
  UserCredential userCredential;

  bool isLoggedIn = false;

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
        isLoggedIn = true;
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
      result = 'Successful Login.';
      isLoggedIn = true;
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
    isLoggedIn = false;
    return true;
  }

  Global._internal();
}