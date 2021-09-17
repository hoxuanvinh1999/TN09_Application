import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/delete_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/view_information_cle.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/location_page/location_function/get_type_color_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/reduce_number_of_location.dart';

showDeleteDialogLocation(
    {required BuildContext context, required Map location}) {
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${location['nomLocation']}'),
          content: Text('Are you sure you want to delete?'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  reduceNumberofLocation(contact_key: location['contact_key']);
                  if (location['nombredecle'] != '0') {
                    deleteCle(location_key: location['key']);
                  }
                  referenceLocation
                      .child(location['key'])
                      .remove()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text('Delete'))
          ],
        );
      });
}
