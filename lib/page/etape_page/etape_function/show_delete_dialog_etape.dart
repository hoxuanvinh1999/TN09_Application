import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/show_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';

showDeleteDialogEtape({required BuildContext context, required Map etape}) {
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
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
                      .whenComplete(() => PlanningPage());
                },
                child: Text('Delete'))
          ],
        );
      });
}
