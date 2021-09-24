import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';

showDeleteDialogPlanning(
    {required BuildContext context, required Map planning}) {
  DatabaseReference referencePlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
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
                onPressed: () async {
                  await referenceEtape.once().then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> etape = snapshot.value;
                    etape.forEach((key, values) {
                      if (values['planning_key'] == planning['key']) {
                        referenceEtape.child(key).remove();
                      }
                    });
                  });
                  await referenceTotalInformation
                      .once()
                      .then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> information = snapshot.value;
                    information.forEach((key, values) {
                      Map<String, String> totalInformation = {
                        'nombredeEtape': (int.parse(values['nombredeEtape']) -
                                int.parse(planning['nombredeEtape']))
                            .toString(),
                        'nombredePlanning':
                            (int.parse(values['nombredePlanning']) - 1)
                                .toString(),
                      };
                      referenceTotalInformation
                          .child(key)
                          .update(totalInformation);
                    });
                  });
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
