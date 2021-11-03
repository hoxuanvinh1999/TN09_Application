import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tn09_app_demo/page/login_page/login_screen.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/blocs/application_bloc.dart';
import '../../widget/navigation_drawer_widget.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  Future<bool?> _onBackPressed(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit your App'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final applicationBloc = Provider.of<ApplicationBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        final goback = await _onBackPressed(context);
        return goback ?? false;
      },
      child: Scaffold(
        drawer: NavigationDrawerWidget(),
        // endDrawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('TN09 Demo Applicaiton'),
        ),
        body: SingleChildScrollView(
          child: Card(
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
                      //update later
                      // auth.signOut();
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => LoginScreen()));
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Image.asset('assets/logo_1.jpg'),
                Text('Demo app homepage'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
