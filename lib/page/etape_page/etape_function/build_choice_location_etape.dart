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
import 'package:tn09_app_demo/page/etape_page/etape_function/confirm_etape.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

Widget buildChoiceLocation(
    {required BuildContext context,
    required Map location,
    required String reason,
    required String numberofEtape}) {
  //print('Into build choice location');
  //print('${location['nomLocation']}');
  return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(10),
      height: 50,
      color: Colors.white,
      child: ButtonWidget(
          icon: Icons.home,
          text: location['nomLocation'],
          onClicked: () {
            if (reason == 'createEtape') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return ConfirmEtape(
                    location: location,
                    reason: 'confirmEtape',
                    numberofEtape: 'null',
                  );
                }),
              );
            } else if (reason == 'createPlanning') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return ConfirmEtape(
                    location: location,
                    reason: 'createPlanning',
                    numberofEtape: numberofEtape,
                  );
                }),
              );
            } else if (reason == 'continuePlanning') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return ConfirmEtape(
                    location: location,
                    reason: 'continuePlanning',
                    numberofEtape: numberofEtape,
                  );
                }),
              );
            } else {
              updateLocationEtape(location: location, etapeKey: reason);
              Navigator.pop(context);
            }
          }));
}

updateLocationEtape({required Map location, required String etapeKey}) async {
  DatabaseReference _refEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  Map<String, String> etape = {
    'nomLocationEtape': location['nomLocation'],
    'nombredebac': location['nombredebac'],
    'addressLocationEtape': location['addressLocation'],
    'location_key': location['key'],
  };
  await _refEtape.child(etapeKey).update(etape);
}
