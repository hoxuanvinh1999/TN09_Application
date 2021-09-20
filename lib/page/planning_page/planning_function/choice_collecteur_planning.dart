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
import 'package:tn09_app_demo/page/planning_page/planning_function/build_choice_collecteur_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class ChoiceCollecteurPlanning extends StatefulWidget {
  String reason;
  ChoiceCollecteurPlanning({required this.reason});
  @override
  _ChoiceCollecteurPlanningState createState() =>
      _ChoiceCollecteurPlanningState();
}

class _ChoiceCollecteurPlanningState extends State<ChoiceCollecteurPlanning> {
  Query _refCollecteur = FirebaseDatabase.instance
      .reference()
      .child('Collecteur')
      .orderByChild('nomCollecteur');

  Widget setTitle() {
    if (widget.reason == 'createPlanning') {
      return Text('Choice Collecteur');
    } else {
      return Text('Change Collecteur');
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
                title: Text('Cancel Change Collecteur?'),
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
            query: _refCollecteur,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map collecteur = snapshot.value;
              collecteur['key'] = snapshot.key;
              return buildChoiceCollecteur(
                  context: context,
                  collecteur: collecteur,
                  reason: widget.reason);
            },
          ),
        ),
      ),
    );
  }
}
