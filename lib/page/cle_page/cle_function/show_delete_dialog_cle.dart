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

showDeleteDialogCle({required BuildContext context, required Map cle}) {
  DatabaseReference referenceCle =
      FirebaseDatabase.instance.reference().child('Cle');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${cle['nomLocation']}'),
          content: Text('Are you sure you want to delete?'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  reduceNumberofKey(location_key: cle['location_key']);
                  referenceCle
                      .child(cle['key'])
                      .remove()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text('Delete'))
          ],
        );
      });
}
