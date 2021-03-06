import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tn09_working_demo/login_page/forget_password_page.dart';
import 'package:tn09_working_demo/login_page/verify_email_page.dart';
import 'package:tn09_working_demo/working_page/working_page.dart';
import 'package:tn09_working_demo/decoration/graphique.dart' as graphique;

class LoginPage extends StatefulWidget {
  final CameraDescription camera;
  LoginPage({
    Key? key,
    required this.camera,
  }) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                    height: 80,
                  ),
                  Image.asset('assets/app_logo.png'),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Les Detritivores',
                    style: TextStyle(
                      color: Color(graphique.color['default_white']),
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 480,
                    width: 400,
                    decoration: BoxDecoration(
                        color: Color(graphique.color['default_white']),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Log In Page',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Log into our DataBase',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(graphique.color['default_grey'])),
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
                        Container(
                          width: 300,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: Icon(
                                FontAwesomeIcons.eyeSlash,
                                size: 17,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _password = value.trim();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 40, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPasswordPage(
                                                  camera: widget.camera,
                                                )));
                                  },
                                  child: Text(
                                    'Forget Password',
                                    style: TextStyle(
                                        color: Colors.orangeAccent[700]),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => _signinAnonymous(),
                          // _signin(_email, _password),
                          child: Container(
                            alignment: Alignment.center,
                            width: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(graphique.color['main_color_1']),
                                      Color(graphique.color['main_color_2']),
                                      // Color(graphique.color['secondary_color_1']),
                                    ])),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Sign In',
                                  style: TextStyle(
                                    color:
                                        Color(graphique.color['default_white']),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            showSignUpDialog(context: context);
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
                                      Color(graphique.color['main_color_1']),
                                      Color(graphique.color['main_color_2']),
                                      // Color(graphique.color['secondary_color_1']),
                                    ])),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Sign Up',
                                  style: TextStyle(
                                    color:
                                        Color(graphique.color['default_white']),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSignUpDialog({required BuildContext context}) {
    String signupEmail = '';
    String signupPassword = '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 480,
              width: 400,
              decoration: BoxDecoration(
                  color: Color(graphique.color['default_white']),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  // Positioned(
                  //   right: 0.0,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //     child: Align(
                  //       alignment: Alignment.topRight,
                  //       child: CircleAvatar(
                  //         radius: 20,
                  //         backgroundColor: Colors.green,
                  //         child: Icon(Icons.close, color: Colors.red),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 30),
                  Text(
                    'Sign Up Form',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sign up to our DataBase',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(graphique.color['default_grey'])),
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
                          signupEmail = value.trim();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: Icon(
                          FontAwesomeIcons.eyeSlash,
                          size: 17,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          signupPassword = value.trim();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _signup(
                          signupEmail: signupEmail,
                          signupPassword: signupPassword);
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
                                Color(graphique.color['main_color_1']),
                                Color(graphique.color['main_color_2']),
                                // Color(graphique.color['secondary_color_1']),
                              ])),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Sign Up',
                            style: TextStyle(
                              color: Color(graphique.color['default_white']),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _signinAnonymous() async {
    await auth.signInAnonymously();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => WorkingPage(
              camera: widget.camera,
              thisDay: DateTime.now(),
            )
        // PlanningDailyPage(
        //       thisDay: DateTime.parse("2021-10-18 20:18:04Z"),
        //     )
        ));
  }

  _signin(String _email, String _password) async {
    try {
      //Create Get Firebase Auth User
      await auth.signInWithEmailAndPassword(email: _email, password: _password);

      //Success
      Fluttertoast.showToast(
          msg: 'Sign In Successed', gravity: ToastGravity.TOP);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => WorkingPage(
                camera: widget.camera,
                thisDay: DateTime.now(),
              )));
    } on FirebaseAuthException catch (error) {
      //String msgerror = 'Error sign in';
      Fluttertoast.showToast(
          msg: (error.message).toString(), gravity: ToastGravity.TOP);
    }
  }

  _signup({required String signupEmail, required String signupPassword}) async {
    try {
      //Create Get Firebase Auth User
      await auth.createUserWithEmailAndPassword(
          email: signupEmail, password: signupPassword);

      //Success
      Fluttertoast.showToast(
          msg: 'Sign Up Successed', gravity: ToastGravity.TOP);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => VerifyScreen(
                camera: widget.camera,
              )));
    } on FirebaseAuthException catch (error) {
      //String msgerror = 'Error sign up';
      Fluttertoast.showToast(
        msg: (error.message).toString(),
        gravity: ToastGravity.TOP,
      );
    }
  }
}
