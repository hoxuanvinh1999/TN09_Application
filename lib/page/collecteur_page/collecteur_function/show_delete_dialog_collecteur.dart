import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

showDeleteDialogCollecteur(
    {required BuildContext context, required Map collecteur}) {
  DatabaseReference referenceCollecteur =
      FirebaseDatabase.instance.reference().child('Collecteur');
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
                onPressed: () {
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
