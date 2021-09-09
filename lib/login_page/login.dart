import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../page/home_page.dart';
import 'reset.dart';
import 'verify.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
              onChanged: (value) {
                setState(() {
                  _password = value.trim();
                });
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('Sign In'),
                onPressed: () => _signin(_email, _password)),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text('Sign Up'),
              onPressed: () => _signup(_email, _password),
            )
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text('Forgot Password?'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ResetScreen()),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _signin(String _email, String _password) async {
    try {
      //Create Get Firebase Auth User
      await auth.signInWithEmailAndPassword(email: _email, password: _password);

      //Success
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (error) {
      String msgerror = 'Error sign in';
      Fluttertoast.showToast(
          msg: (error.message).toString(), gravity: ToastGravity.TOP);
    }
  }

  _signup(String _email, String _password) async {
    try {
      //Create Get Firebase Auth User
      await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      //Success
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (error) {
      String msgerror = 'Error sign up';
      Fluttertoast.showToast(
        msg: (error.message).toString(),
        gravity: ToastGravity.TOP,
      );
    }
  }
}
