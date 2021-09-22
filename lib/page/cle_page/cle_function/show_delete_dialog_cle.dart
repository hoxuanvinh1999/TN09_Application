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
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
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
                onPressed: () async {
                  reduceNumberofKey(location_key: cle['location_key']);
                  await referenceTotalInformation
                      .once()
                      .then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> etape = snapshot.value;
                    etape.forEach((key, values) {
                      Map<String, String> totalInformation = {
                        'nombredeCle':
                            (int.parse(values['nombredeCle']) - 1).toString(),
                      };
                      referenceTotalInformation
                          .child(key)
                          .update(totalInformation);
                    });
                  });
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
