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
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  String number_key = '';
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
                onPressed: () async {
                  reduceNumberofLocation(contact_key: location['contact_key']);
                  if (location['nombredecle'] != '0') {
                    deleteCle(location_key: location['key']);
                  }
                  number_key = location['nombredecle'];
                  await referenceTotalInformation
                      .once()
                      .then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> etape = snapshot.value;
                    etape.forEach((key, values) {
                      Map<String, String> totalInformation = {
                        'nombredeLocation':
                            (int.parse(values['nombredeLocation']) - 1)
                                .toString(),
                        'nombredeCle': (int.parse(values['nombredeCle']) -
                                int.parse(number_key))
                            .toString(),
                      };
                      referenceTotalInformation
                          .child(key)
                          .update(totalInformation);
                    });
                  });
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
