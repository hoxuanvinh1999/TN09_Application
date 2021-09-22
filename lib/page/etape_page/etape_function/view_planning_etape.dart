import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/build_item_contact.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_item_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_item_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';

class ViewPlanningEtape extends StatefulWidget {
  String planning_key;
  ViewPlanningEtape({required this.planning_key});
  @override
  _ViewPlanningEtapeState createState() => _ViewPlanningEtapeState();
}

class _ViewPlanningEtapeState extends State<ViewPlanningEtape> {
  Query ReferencePlanning = FirebaseDatabase.instance
      .reference()
      .child('Planning')
      .orderByChild('startdate');
  DatabaseReference referencePlanning =
      FirebaseDatabase.instance.reference().child('Planning');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information Planning'),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: ReferencePlanning,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map planning = snapshot.value;
            planning['key'] = snapshot.key;
            if (planning['key'] == widget.planning_key) {
              return buildItemPlanning(context: context, planning: planning);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
