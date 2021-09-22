import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/delete_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/view_information_cle.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/location_page/location_function/get_type_color_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/reduce_number_of_location.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';

showRemoveEtapeDialogPlanning(
    {required BuildContext context,
    required etape_key,
    required Map planning}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove this Etape'),
          content: Text('Are you sure you want to remove?'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  updateState(etape_key: etape_key, planning: planning);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlanningPage()),
                  );
                },
                child: Text('Delete'))
          ],
        );
      });
}

updateState({required etape_key, required Map planning}) async {
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referencePlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  String beforeEtape_key = '';
  String afterEtape_key = '';
  String newStartEtape_key = '';
  String total_key = '';
  await referenceTotalInformation.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      total_key = key;
    });
  });
  await referenceEtape.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      if (key == etape_key) {
        if (values['beforeEtape_key'] == 'null' &&
            values['afterEtape_key'] == 'null') {
          referencePlanning.child(planning['key']).remove();
          Map<String, String> totalInformation = {
            'nombredePlanning':
                (int.parse(values['nombredePlanning']) - 1).toString(),
          };
          referenceTotalInformation.child(total_key).update(totalInformation);
          return;
        } else if (values['beforeEtape_key'] == 'null') {
          newStartEtape_key = values['afterEtape_key'];
          afterEtape_key = values['afterEtape_key'];
          Map<String, String> update_planning = {
            'startetape_key': newStartEtape_key,
            'nombredeEtape':
                (int.parse(planning['nombredeEtape']) - 1).toString(),
          };
          referencePlanning.child(planning['key']).update(update_planning);
          Map<String, String> update_etape = {
            'afterEtape_key': 'null',
          };
          referenceEtape.child(etape_key).update(update_etape);
        } else if (values['afterEtape_key'] == 'null') {
          Map<String, String> update_planning = {
            'nombredeEtape':
                (int.parse(planning['nombredeEtape']) - 1).toString(),
          };
          referencePlanning.child(planning['key']).update(update_planning);
          beforeEtape_key = values['beforeEtape_key'];
          Map<String, String> update_etape = {
            'beforeEtape_key': 'null',
          };
          referenceEtape.child(etape_key).update(update_etape);
        } else {
          beforeEtape_key = values['beforeEtape_key'];
          afterEtape_key = values['afterEtape_key'];
          Map<String, String> update_planning = {
            'nombredeEtape':
                (int.parse(planning['nombredeEtape']) - 1).toString(),
          };
          referencePlanning.child(planning['key']).update(update_planning);
          Map<String, String> update_etape = {
            'beforeEtape_key': 'null',
            'afterEtape_key': 'null',
          };
          referenceEtape.child(etape_key).update(update_etape);
        }
      }
    });
  });
  if (beforeEtape_key != '' && afterEtape_key != '') {
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        if (key == beforeEtape_key) {
          Map<String, String> update_before_etape = {
            'afterEtape_key': afterEtape_key,
          };
          referenceEtape.child(key).update(update_before_etape);
        } else if (key == afterEtape_key) {
          Map<String, String> update_after_etape = {
            'beforeEtape_key': beforeEtape_key,
          };
          referenceEtape.child(key).update(update_after_etape);
        }
      });
    });
    return;
  } else if (beforeEtape_key != '') {
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        if (key == beforeEtape_key) {
          Map<String, String> update_before_etape = {
            'afterEtape_key': 'null',
          };
          referenceEtape.child(key).update(update_before_etape);
        }
      });
    });
    return;
  } else {
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        if (key == afterEtape_key) {
          Map<String, String> update_after_etape = {
            'beforeEtape_key': 'null',
          };
          referenceEtape.child(key).update(update_after_etape);
        }
      });
    });
    return;
  }
}
