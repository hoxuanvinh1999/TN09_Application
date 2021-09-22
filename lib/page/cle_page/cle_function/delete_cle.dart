import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

// This function help us to delete all cle corresponding to a location
deleteCle({required String location_key}) async {
  //int i = 0;
  print('Into delete Cle');
  print('location key $location_key');
  DatabaseReference referencedeleteCle =
      FirebaseDatabase.instance.reference().child('Cle');
  // DatabaseReference referenceTotalInformation =
  // FirebaseDatabase.instance.reference().child('TotalInformation');
  await referencedeleteCle.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> cle = snapshot.value;
    cle.forEach((key, values) {
      /*Here, cle contains every cle in the database
      the form of cle is {key: {noteCle, type,..}, key:{noteCle, type},...}
      so to access to each cle, we will use values
      */
      print('Into for Each');
      print('value key ${values['key']}');
      //values do not have 'key', it just have {noteCle, type...}
      print('$values');
      print('value location_key ${values['location_key']}');
      if (values['location_key'] == location_key) {
        print('Into If right');
        // i++;
        FirebaseDatabase.instance.reference().child('Cle').child(key).remove();
      }
    });
  });
  /* print('dddddddddddddddddddddddddd');
  await referenceTotalInformation.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      Map<String, String> totalInformation = {
        'nombredeCle': (int.parse(values['nombredeCle']) - i).toString(),
      };
      referenceTotalInformation.child(key).update(totalInformation);
    });
  });
  */
}
