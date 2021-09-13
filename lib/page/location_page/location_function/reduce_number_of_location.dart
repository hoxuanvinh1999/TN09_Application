import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/view_information_cle.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/location_page/location_function/get_type_color_location.dart';
import 'create_location.dart';
import 'update_location.dart';

void reduceNumberofLocation({required String contact_key}) async {
  DatabaseReference _refContact =
      FirebaseDatabase.instance.reference().child('Contact');
  String cleTableSecurityPass = 'check';
  DataSnapshot snapshotcontact = await _refContact.child(contact_key).once();
  Map contact = snapshotcontact.value;
  String numberofLocation = contact['nombredelocation'];
  numberofLocation = (int.parse(numberofLocation) - 1).toString();
  Map<String, String> updatecontact = {
    'nombredelocation': numberofLocation,
  };
  _refContact.child(contact_key).update(updatecontact);
}
