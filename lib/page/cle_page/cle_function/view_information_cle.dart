import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/build_item_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/get_type_color_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/reduce_number_of_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/update_cle.dart';

class ViewInformationCle extends StatefulWidget {
  String locationKey;

  ViewInformationCle({required this.locationKey});

  @override
  _ViewInformationCleState createState() => _ViewInformationCleState();
}

class _ViewInformationCleState extends State<ViewInformationCle> {
  String nameLocation = '';
  String addressLocation = '';
  String numberofKey = '';
  String typeLocation = '';
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference _refCle =
      FirebaseDatabase.instance.reference().child('Cle');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Cle Information'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query:
              _refCle.orderByChild('location_key').equalTo(widget.locationKey),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map cle = snapshot.value;
            cle['key'] = snapshot.key;
            return buildCleItem(context: context, cle: cle);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return CreateCle(locationKey: widget.locationKey);
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
