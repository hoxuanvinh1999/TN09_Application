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
import 'package:tn09_app_demo/page/planning_page/planning_function/finish_create_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/show_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

Widget buildChoiceCollecteur(
    {required BuildContext context,
    required Map collecteur,
    required String reason}) {
  //print('Into build choice location');
  //print('${location['nomLocation']}');
  return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(10),
      height: 50,
      color: Colors.white,
      child: ButtonWidget(
          icon: Icons.person,
          text: collecteur['prenomCollecteur'] +
              ' ' +
              collecteur['nomCollecteur'],
          onClicked: () {
            if (reason == 'createPlanning') {
              updatePlanning(collecteur: collecteur);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return FinishCreatePlanning();
                }),
              );
            } else {
              changeCollecteurPlanning(
                  collecteur_key: collecteur['key'], planning_key: reason);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return ShowPlanning();
                }),
              );
            }
          }));
}

updatePlanning({required Map collecteur}) async {
  DatabaseReference _refPlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  await _refPlanning.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> planning = snapshot.value;
    planning.forEach((key, values) {
      if (values['finished_create'] == 'false') {
        print('Into If right');
        Map<String, String> planning = {
          'collecteur_key': collecteur['key'],
        };
        _refPlanning.child(key).update(planning);
      }
    });
  });
}

changeCollecteurPlanning(
    {required String collecteur_key, required String planning_key}) async {
  DatabaseReference _refPlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  await _refPlanning.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> planning = snapshot.value;
    planning.forEach((key, values) {
      if (key == planning_key) {
        print('Into If right');
        Map<String, String> planning = {
          'collecteur_key': collecteur_key,
        };
        _refPlanning.child(key).update(planning);
      }
    });
  });
}
