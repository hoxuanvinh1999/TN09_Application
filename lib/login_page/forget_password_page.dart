import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tn09_working_demo/login_page/login_page.dart';
import 'package:tn09_working_demo/math_function/check_email.dart';
import 'package:tn09_working_demo/decoration/graphique.dart' as graphique;

class ForgetPasswordPage extends StatefulWidget {
  final CameraDescription camera;
  ForgetPasswordPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  String _email = '';
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    camera: widget.camera,
                  )),
        );
        return false;
      },
      child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.centerRight,
                          colors: [
                        Color(graphique.color['main_color_1']),
                        Color(graphique.color['main_color_2']),
                        // Color(graphique.color['secondary_color_1']),
                      ])),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 300,
                          width: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Forget Password',
                                style: TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Reset your password',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 300,
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    suffixIcon: Icon(
                                      FontAwesomeIcons.envelope,
                                      size: 17,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _email = value.trim();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_email == null ||
                                      _email.isEmpty ||
                                      _email == '') {
                                    Fluttertoast.showToast(
                                        msg: 'Please input your email',
                                        gravity: ToastGravity.TOP);
                                  } else if (!checkEmail(_email)) {
                                    Fluttertoast.showToast(
                                        msg: 'Please input a correct email',
                                        gravity: ToastGravity.TOP);
                                  } else {
                                    QuerySnapshot query =
                                        await FirebaseFirestore.instance
                                            .collection('User')
                                            .where('email', isEqualTo: _email)
                                            .get();
                                    if (query.docs.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'There are no accounts with this email, you may be signing up for a new account',
                                          gravity: ToastGravity.TOP);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Password reset instructions have been sent to email!',
                                          gravity: ToastGravity.TOP);
                                      auth.sendPasswordResetEmail(
                                          email: _email);
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) => LoginPage(
                                                    camera: widget.camera,
                                                  )));
                                    }
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          begin: Alignment.center,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(graphique
                                                .color['main_color_1']),
                                            Color(graphique
                                                .color['main_color_2']),
                                            // Color(graphique.color['secondary_color_1']),
                                          ])),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text('Send Request',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]))))),
    );
  }
}
