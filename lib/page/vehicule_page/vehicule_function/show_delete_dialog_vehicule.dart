import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

showDeleteDialogVehicule(
    {required BuildContext context, required Map vehicule}) {
  DatabaseReference referenceVehicule =
      FirebaseDatabase.instance.reference().child('Vehicule');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${vehicule['numeroimmatriculation']}'),
          content: Text('Are you sure you want to delete?'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () async {
                  await referenceTotalInformation
                      .once()
                      .then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> etape = snapshot.value;
                    etape.forEach((key, values) {
                      Map<String, String> totalInformation = {
                        'nombredeVehicule':
                            (int.parse(values['nombredeVehicule']) - 1)
                                .toString(),
                      };
                      referenceTotalInformation
                          .child(key)
                          .update(totalInformation);
                    });
                  });
                  referenceVehicule
                      .child(vehicule['key'])
                      .remove()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text('Delete'))
          ],
        );
      });
}
