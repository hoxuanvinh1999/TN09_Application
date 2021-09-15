import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_collecteur_part_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_etape_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_vehicule_part_planning.dart';

Widget buildItemPlanning(
    {required BuildContext context, required Map planning}) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(10),
      height: 800,
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Date: ' + planning['startdate'],
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          buildCollecteurPlanning(
              context: context, collecteur_key: planning['collecteur_key']),
          buildVehiculePlanning(
              context: context, vehicule_key: planning['vehicule_key']),
          buildEtapePlanning(
              context: context, etape_key: planning['startetape_key']),
        ],
      ));
}
