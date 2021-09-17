import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/remove_etape_planning.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class EditEtapePlanning extends StatefulWidget {
  Map planning;
  List<String> listKeyEtape;
  List<String> listNomLocationEtape;
  List<String> listAddressLocationEtape;
  List<String> listKeyLocation;
  List<String> listKeyContact;
  EditEtapePlanning(
      {required this.planning,
      required this.listKeyEtape,
      required this.listNomLocationEtape,
      required this.listAddressLocationEtape,
      required this.listKeyLocation,
      required this.listKeyContact});
  @override
  _EditEtapePlanningState createState() => _EditEtapePlanningState();
}

class _EditEtapePlanningState extends State<EditEtapePlanning> {
  List<Widget> buttonsList = [];
  List<Widget> _buildEtapeButtons() {
    for (int i = 0; i < int.parse(widget.planning['nombredeEtape']); i++) {
      print('${widget.listKeyContact[i]}');
      buttonsList.add(new Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.green,
          width: 2,
        )),
        child: Row(
          children: [
            GestureDetector(
              onLongPress: () {
                showRemoveEtapeDialogPlanning(
                    context: context,
                    etape_key: widget.listKeyEtape[i],
                    planning: widget.planning);
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ViewContact(contactKey: widget.listKeyContact[0])));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.home,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                      widget.listNomLocationEtape[i] +
                          '  ' +
                          widget.listAddressLocationEtape[i],
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return buttonsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Etape Planning'),
        ),
        body: Wrap(children: _buildEtapeButtons()));
  }
}
