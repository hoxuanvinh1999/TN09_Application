import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/delete_cle.dart';

//help us to delete all the location corresponding to the contact we want to delete

deleteLocation({required String contact_key}) async {
  print('Into delete Location');
  print('contact key $contact_key');
  int i = 0;
  int number_cle = 0;
  DatabaseReference referencedeleteLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  await referencedeleteLocation.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> location = snapshot.value;
    location.forEach((key, values) {
      print('Into for Each');
      print('$values');
      print('value contact_key ${values['key']}');
      print('key is $key');
      if (values['contact_key'] == contact_key) {
        print('Into If right');
        if (values['nombredecle'] != '0') {
          deleteCle(location_key: key);
        }
        i++;
        number_cle += int.parse(values['nombredecle']);
        //reduceNumberofCle(location_key: key);
        FirebaseDatabase.instance
            .reference()
            .child('Location')
            .child(key)
            .remove();
      }
    });
  });
  print('qqqqqqqqqqqqqqqqqqq');
  await referenceTotalInformation.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> information = snapshot.value;
    information.forEach((key, values) {
      Map<String, String> totalInformation = {
        'nombredeLocation':
            (int.parse(values['nombredeLocation']) - i).toString(),
        'nombredeCle':
            (int.parse(values['nombredeCle']) - number_cle).toString(),
      };
      referenceTotalInformation.child(key).update(totalInformation);
    });
  });
}
