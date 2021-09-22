import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/location_page/location_function/delete_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/create_location.dart';
import 'create_contact.dart';
import 'update_contact.dart';

showDeleteDialogContact({required BuildContext context, required Map contact}) {
  DatabaseReference referenceContact =
      FirebaseDatabase.instance.reference().child('Contact');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${contact['nomcontact']}'),
          content: Text('Are you sure you want to delete?'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () async {
                  String contact_key = contact['key'];
                  if (contact['nombredelocation'] != '0') {
                    deleteLocation(contact_key: contact_key);
                  }
                  await referenceTotalInformation
                      .once()
                      .then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> etape = snapshot.value;
                    etape.forEach((key, values) {
                      Map<String, String> totalInformation = {
                        'nombredeContact':
                            (int.parse(values['nombredeContact']) - 1)
                                .toString(),
                      };
                      referenceTotalInformation
                          .child(key)
                          .update(totalInformation);
                    });
                  });
                  referenceContact
                      .child(contact['key'])
                      .remove()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text('Delete'))
          ],
        );
      });
}
