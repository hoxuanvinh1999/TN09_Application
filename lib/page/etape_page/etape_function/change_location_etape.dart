import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_choice_location_etape.dart';

class ChangeLocationEtape extends StatefulWidget {
  String etapeKey;
  ChangeLocationEtape({required this.etapeKey});
  @override
  _ChangeLocationEtapeState createState() => _ChangeLocationEtapeState();
}

class _ChangeLocationEtapeState extends State<ChangeLocationEtape> {
  Query _refLocation = FirebaseDatabase.instance
      .reference()
      .child('Location')
      .orderByChild('nomeLocation');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Location'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _refLocation,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map location = snapshot.value;
            location['key'] = snapshot.key;
            return buildChoiceLocation(
                context: context, location: location, reason: widget.etapeKey);
          },
        ),
      ),
    );
  }
}
