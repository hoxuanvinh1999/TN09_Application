import 'package:flutter/material.dart';
import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

void deleteCreatingPlanningProcess() async {
  DatabaseReference referenceProcessEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referenceProcessPlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  DatabaseReference referenceProcessLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  await referenceProcessLocation.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> location = snapshot.value;
    location.forEach((key, values) {
      if (values['showed'] == 'true') {
        Map<String, String> update_location = {
          'showed': 'false',
        };
        referenceProcessLocation.child(key).update(update_location);
      }
    });
  });
  await referenceProcessEtape.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      if (values['showed'] == 'true') {
        Map<String, String> update_etape = {
          'showed': 'false',
        };
        referenceProcessEtape.child(key).update(update_etape);
      }
    });
  });
  await referenceProcessEtape.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      if (values['checked'] == 'creating') {
        referenceProcessEtape.child(key).remove();
      }
    });
  });

  String numberofEtape = '';
  await referenceProcessPlanning.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      if (values['finished_create'] == 'false') {
        numberofEtape = values['nombredeEtape'];
        referenceProcessPlanning.child(key).remove();
      }
    });
  });

  await referenceTotalInformation.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      Map<String, String> totalInformation = {
        'nombredeEtape':
            (int.parse(values['nombredeEtape']) - int.parse(numberofEtape))
                .toString(),
      };
      referenceTotalInformation.child(key).update(totalInformation);
    });
  });
}
