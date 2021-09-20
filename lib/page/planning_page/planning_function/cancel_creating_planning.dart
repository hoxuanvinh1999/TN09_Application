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
  DatabaseReference _refProcessEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference _refProcessPlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  await _refProcessEtape.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      if (values['checked'] == 'creating') {
        _refProcessEtape.child(key).remove();
      }
    });
  });
  await _refProcessPlanning.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> etape = snapshot.value;
    etape.forEach((key, values) {
      if (values['finished_create'] == 'false') {
        _refProcessPlanning.child(key).remove();
      }
    });
  });
}
