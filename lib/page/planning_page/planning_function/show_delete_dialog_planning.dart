import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';

showDeleteDialogPlanning(
    {required BuildContext context, required Map planning}) {
  DatabaseReference referencePlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Planning'),
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
                  referencePlanning
                      .child(planning['key'])
                      .remove()
                      .whenComplete(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlanningPage()),
                    );
                  });
                },
                child: Text('Delete'))
          ],
        );
      });
}
