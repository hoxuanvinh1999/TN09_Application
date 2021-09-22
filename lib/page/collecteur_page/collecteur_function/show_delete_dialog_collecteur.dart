import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

showDeleteDialogCollecteur(
    {required BuildContext context, required Map collecteur}) {
  DatabaseReference referenceCollecteur =
      FirebaseDatabase.instance.reference().child('Collecteur');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${collecteur['nomCollecteur']}'),
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
                        'nombredeCollecteur':
                            (int.parse(values['nombredeCollecteur']) - 1)
                                .toString(),
                      };
                      referenceTotalInformation
                          .child(key)
                          .update(totalInformation);
                    });
                  });
                  referenceCollecteur
                      .child(collecteur['key'])
                      .remove()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text('Delete'))
          ],
        );
      });
}
