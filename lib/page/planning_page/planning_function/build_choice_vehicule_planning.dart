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
import 'package:tn09_app_demo/page/planning_page/planning_function/choice_collecteur_planning.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

Widget buildChoiceVehicule(
    {required BuildContext context,
    required Map vehicule,
    required String reason}) {
  //print('Into build choice location');
  //print('${location['nomLocation']}');
  return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(10),
      height: 50,
      color: Colors.white,
      child: ButtonWidget(
          icon: Icons.car_rental,
          text: vehicule['typeVehicule'] +
              ' ' +
              vehicule['numeroimmatriculation'],
          onClicked: () {
            if (true || reason == 'createPlanning') {
              updatePlanning(vehicule: vehicule);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return ChoiceCollecteurPlanning(reason: 'createPlanning');
                }),
              );
            }
          }));
}

updatePlanning({required Map vehicule}) async {
  DatabaseReference _refPlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  await _refPlanning.once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> planning = snapshot.value;
    planning.forEach((key, values) {
      if (values['finished_create'] == 'false') {
        print('Into If right');
        Map<String, String> planning = {
          'vehicule_key': vehicule['key'],
        };
        _refPlanning.child(key).update(planning);
      }
    });
  });
}
