import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/build_item_contact.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_item_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_item_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';

class ShowPlanning extends StatefulWidget {
  @override
  _ShowPlanningState createState() => _ShowPlanningState();
}

class _ShowPlanningState extends State<ShowPlanning> {
  Query _refPlanning = FirebaseDatabase.instance
      .reference()
      .child('Planning')
      .orderByChild('startdate');
  DatabaseReference referencePlanning =
      FirebaseDatabase.instance.reference().child('Planning');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Planning'),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _refPlanning,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map planning = snapshot.value;
            planning['key'] = snapshot.key;
            return buildItemPlanning(context: context, planning: planning);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return PlanningPage();
            }),
          );
        },
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}
