import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Testing'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(44.85552543453359, -0.5484378447808893),
                zoom: 15),
          ),
        ),
      );
}
