import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

deleteCle({required String location_key}) {
  print('Into delete Cle');
  print('location key $location_key');
  DatabaseReference _refdeleteCle =
      FirebaseDatabase.instance.reference().child('Cle');
  _refdeleteCle.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> cle = snapshot.value;
    cle.forEach((key, values) {
      print('Into for Each');
      print('value key ${cle['key']}');
      print('$cle');
      print('value location_key ${cle['location_key']}');
      if (cle['location_key'] == location_key) {
        print('Into If right');
        FirebaseDatabase.instance.reference().child('Cle').child(key).remove();
      }
    });
  });
}
