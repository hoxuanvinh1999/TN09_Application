import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

showDeleteDialogEtape({required BuildContext context, required Map etape}) {
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Etape'),
          content: Text('Are you sure you want to delete?'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  //will update in the future
                  referenceEtape
                      .child(etape['key'])
                      .remove()
                      .whenComplete(() => Navigator.pop(context));
                },
                child: Text('Delete'))
          ],
        );
      });
}
