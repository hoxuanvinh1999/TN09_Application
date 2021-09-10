import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../cle_page.dart';

class DeleteCle extends StatefulWidget {
  String locationKey;

  DeleteCle({required this.locationKey});

  @override
  _DeleteCleState createState() => _DeleteCleState();
}

class _DeleteCleState extends State<DeleteCle> {
  Query _referenceCle = FirebaseDatabase.instance
      .reference()
      .child('Cle')
      .orderByChild('noteCle');
  DatabaseReference _refCle =
      FirebaseDatabase.instance.reference().child('Cle');
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Cle'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _referenceCle,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map cle = snapshot.value;
            cle['key'] = snapshot.key;
            if (cle['key'] == widget.locationKey) {
              _refCle.child(cle['key']).remove();
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
