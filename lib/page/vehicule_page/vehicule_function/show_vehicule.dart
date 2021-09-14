import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/vehicule_page/vehicule_function/build_item_vehicule.dart';
import 'package:tn09_app_demo/page/vehicule_page/vehicule_function/create_vehicule.dart';

class ShowVehicule extends StatefulWidget {
  @override
  _ShowVehiculeState createState() => _ShowVehiculeState();
}

class _ShowVehiculeState extends State<ShowVehicule> {
  Query _refVehicule = FirebaseDatabase.instance
      .reference()
      .child('Vehicule')
      .orderByChild('nomVehicule');
  DatabaseReference referenceVehicule =
      FirebaseDatabase.instance.reference().child('Vehicule');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Vehicule'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _refVehicule,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map vehicule = snapshot.value;
            vehicule['key'] = snapshot.key;
            return buildItemVehicule(context: context, vehicule: vehicule);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return CreateVehicule();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
