import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/etape_page/etape_page.dart';
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
                  deleteEtape(context: context, etape: etape);
                  referenceEtape.child(etape['key']).remove();
                  Navigator.pop(context);
                },
                child: Text('Delete'))
          ],
        );
      });
}

deleteEtape({required BuildContext context, required Map etape}) async {
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referencePlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  String beforeEtape_key = etape['beforeEtape_key'];
  String afterEtape_key = etape['afterEtape_key'];
  String new_startEtape_key = '';
  await referenceTotalInformation.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> information = snapshot.value;
    information.forEach((key, values) {
      Map<String, String> totalInformation = {
        'nombredeEtape': (int.parse(values['nombredeEtape']) - 1).toString(),
      };
      referenceTotalInformation.child(key).update(totalInformation);
    });
  });
  if (beforeEtape_key == 'null' && afterEtape_key == 'null') {
    print('both before and after is null');
    if (etape['planning_key'] != 'null') {
      await referencePlanning.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> planning = snapshot.value;
        planning.forEach((key, values) {
          if (key == etape['planning_key']) {
            referencePlanning.child(key).remove();
          }
        });
      });

      await referenceTotalInformation.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> information = snapshot.value;
        information.forEach((key, values) {
          Map<String, String> totalInformation = {
            'nombredePlanning':
                (int.parse(values['nombredePlanning']) - 1).toString(),
          };
          referenceTotalInformation.child(key).update(totalInformation);
        });
      });
    }
    return;
  } else if (beforeEtape_key == 'null') {
    print('before is null');

    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (key == etape['afterEtape_key']) {
          print('update after etape');
          Map<String, String> update_after_etape = {
            'beforeEtape_key': 'null',
          };
          new_startEtape_key = key;
          referenceEtape.child(key).update(update_after_etape);
        }
      });
    });

    await referencePlanning.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == etape['planning_key']) {
          Map<String, String> update_planning = {
            'startetape_key': new_startEtape_key,
            'nombredeEtape':
                (int.parse(values['nombredeEtape']) - 1).toString(),
          };
          referencePlanning.child(key).update(update_planning);
        }
      });
    });

    return;
  } else if (afterEtape_key == 'null') {
    print('after is null');
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (key == etape['beforeEtape_key']) {
          Map<String, String> update_before_etape = {
            'afterEtape_key': 'null',
          };
          referenceEtape.child(key).update(update_before_etape);
        }
      });
    });

    await referencePlanning.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == etape['planning_key']) {
          Map<String, String> update_planning = {
            'nombredeEtape':
                (int.parse(values['nombredeEtape']) - 1).toString(),
          };
          referencePlanning.child(key).update(update_planning);
        }
      });
    });

    return;
  } else {
    print('both is not null');
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (key == etape['beforeEtape_key']) {
          Map<String, String> update_before_etape = {
            'afterEtape_key': etape['afterEtape_key'],
          };
          referenceEtape.child(key).update(update_before_etape);
        }
      });
    });
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        if (key == etape['afterEtape_key']) {
          Map<String, String> update_after_etape = {
            'beforeEtape_key': etape['beforeEtape_key'],
          };
          new_startEtape_key = key;
          referenceEtape.child(key).update(update_after_etape);
        }
      });
    });

    await referencePlanning.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == etape['planning_key']) {
          Map<String, String> update_planning = {
            'nombredeEtape':
                (int.parse(values['nombredeEtape']) - 1).toString(),
          };
          referencePlanning.child(key).update(update_planning);
        }
      });
    });
    return;
  }
}
