import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/change_location_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/show_delete_dialog_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/update_etape.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_information_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_location.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/choice_vehicule_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/next_step_create_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/open_list_etape_planning.dart';
import 'package:tn09_app_demo/widget/border_decoration.dart';

Widget buildChoiceEtape(
    {required BuildContext context,
    required Map etape,
    required String reason,
    required String numberofEtape}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NextStepCreatePlanning(
                  etape: etape,
                  reason: reason,
                  numberofEtape: numberofEtape,
                  context: context,
                )),
      );
    },
    child: Container(
      decoration: buildBorderDecoration(),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(10),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                'Nom de la Location: ' + etape['nomLocationEtape'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  'Address de la Location:  ' + etape['addressLocationEtape'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Icon(
                Icons.restore_from_trash,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Material: ' + etape['materialEtape'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Icon(
                Icons.restore_from_trash,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Nombre de bac ' + etape['nombredebac'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Icon(
                Icons.sticky_note_2,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Note ' + etape['noteEtape'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
