import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/build_item_contact.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_item_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_choice_etape_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';

class OpenListEtape extends StatefulWidget {
  String reason;
  String numberofEtape;
  OpenListEtape({required this.reason, required this.numberofEtape});
  @override
  _OpenListEtapeState createState() => _OpenListEtapeState();
}

class _OpenListEtapeState extends State<OpenListEtape> {
  Query _refEtape =
      FirebaseDatabase.instance.reference().child('Etape').orderByChild('key');
  DatabaseReference referenceEptae =
      FirebaseDatabase.instance.reference().child('Contact');

  Future<bool?> dialogDecide(BuildContext context) async {
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
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                )
              ],
            ));
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
            title: Text('List Etape'),
            /*
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),*/
          ),
          body: Container(
            height: double.infinity,
            child: FirebaseAnimatedList(
              query: _refEtape,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map etape = snapshot.value;
                etape['key'] = snapshot.key;
                if (etape['showed'] == 'false') {
                  return buildChoiceEtape(
                      context: context,
                      etape: etape,
                      reason: widget.reason,
                      numberofEtape: widget.numberofEtape);
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ));
  }
}
