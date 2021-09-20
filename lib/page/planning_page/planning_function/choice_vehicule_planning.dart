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
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_choice_vehicule_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/show_planning.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class ChoiceVehiculePlanning extends StatefulWidget {
  String reason;
  ChoiceVehiculePlanning({required this.reason});
  @override
  _ChoiceVehiculePlanningState createState() => _ChoiceVehiculePlanningState();
}

class _ChoiceVehiculePlanningState extends State<ChoiceVehiculePlanning> {
  Query _refVehicule = FirebaseDatabase.instance
      .reference()
      .child('Vehicule')
      .orderByChild('numeroimmatriculation');

  Widget setTitle() {
    if (widget.reason == 'createPlanning') {
      return Text('Choice Vehicule');
    } else {
      return Text('Change Vehicule');
    }
  }

  Future<bool?> dialogDecide(BuildContext context) async {
    if (widget.reason == 'createPlanning') {
      return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Cancel Create New Planning?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      deleteCreatingPlanningProcess();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  )
                ],
              ));
    } else {
      return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Cancel Change Vehicule?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final goback = await dialogDecide(context);
        return goback ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: setTitle(),
        ),
        body: Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: _refVehicule,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map vehicule = snapshot.value;
              vehicule['key'] = snapshot.key;
              return buildChoiceVehicule(
                  context: context, vehicule: vehicule, reason: widget.reason);
            },
          ),
        ),
      ),
    );
  }
}
