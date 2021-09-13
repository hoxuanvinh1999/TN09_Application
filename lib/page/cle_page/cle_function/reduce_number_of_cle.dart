import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void reduceNumberofKey({required String location_key}) async {
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');
  String cleTableSecurityPass = 'check';
  DataSnapshot snapshotlocation =
      await referenceLocation.child(location_key).once();
  Map location = snapshotlocation.value;
  String nombreofCle = location['nombredecle'];
  nombreofCle = (int.parse(nombreofCle) - 1).toString();
  Map<String, String> updatelocation = {
    'nombredecle': nombreofCle,
  };
  referenceLocation.child(location_key).update(updatelocation);
}
