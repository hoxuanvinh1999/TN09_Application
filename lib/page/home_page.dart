import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login_page/login.dart';
import '../widget/navigation_drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        // endDrawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('TN09 Demo Applicaiton'),
        ),
        body: Card(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Image.asset('assets/logo_1.jpg'),
              Text('Demo app homepage'),
            ],
          ),
        ),
      );
}
