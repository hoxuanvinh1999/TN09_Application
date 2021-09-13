import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/build_item_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/get_type_color_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/reduce_number_of_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/update_cle.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_location.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';

class ShowCle extends StatefulWidget {
  @override
  _ShowCleState createState() => _ShowCleState();
}

class _ShowCleState extends State<ShowCle> {
  Query _refCle = FirebaseDatabase.instance
      .reference()
      .child('Cle')
      .orderByChild('noteCle');
  DatabaseReference referenceCle =
      FirebaseDatabase.instance.reference().child('Cle');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Cle'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _refCle,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map cle = snapshot.value;
            cle['key'] = snapshot.key;
            return buildItemCle(context: context, cle: cle);
          },
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return CreateLocation();
            }),
          );
          */
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      */
    );
  }
}
