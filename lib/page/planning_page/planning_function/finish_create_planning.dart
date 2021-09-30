import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class FinishCreatePlanning extends StatefulWidget {
  @override
  _FinishCreatePlanningState createState() => _FinishCreatePlanningState();
}

class _FinishCreatePlanningState extends State<FinishCreatePlanning> {
  final _planningKeyForm = GlobalKey<FormState>();

  DatabaseReference referencePlanning =
      FirebaseDatabase.instance.reference().child('Planning');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');

  DateTime date = DateTime.now();

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('MM/dd/yyyy').format(date);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year - 25),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              deleteCreatingPlanningProcess();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          title: const Text('Finish Create Planning'),
        ),
        body: Container(
            margin: EdgeInsets.all(15),
            height: double.infinity,
            child: Form(
              key: _planningKeyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 30,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Start date: ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 6),
                  ButtonWidget(
                    icon: Icons.calendar_today,
                    text: DateFormat('yMd').format(date).toString(),
                    onClicked: () => pickDate(context),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: RaisedButton(
                      child: Text(
                        'Finish Create Planning',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        if (_planningKeyForm.currentState!.validate()) {
                          SavePlanning();
                        }
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void SavePlanning() async {
    String planning_key = '';
    String startdate = DateFormat('yMd').format(date).toString();
    await referencePlanning.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (values['finished_create'] == 'false') {
          print('Into If right');
          planning_key = key;
          Map<String, String> planning = {
            'startdate': startdate,
            'finished_create': 'true',
          };
          referencePlanning.child(key).update(planning).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlanningPage()),
            );
          });
        }
      });
    });
    await referenceLocation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> location = snapshot.value;
      location.forEach((key, values) {
        if (values['showed'] == 'true') {
          Map<String, String> update_location = {
            'showed': 'false',
          };
          referenceLocation.child(key).update(update_location);
        }
      });
    });
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        if (values['showed'] == 'true') {
          Map<String, String> update_etape = {
            'showed': 'false',
          };
          referenceEtape.child(key).update(update_etape);
        }
      });
    });
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        if (values['checked'] == 'creating') {
          Map<String, String> update_etape = {
            'checked': 'false',
            'planning_key': planning_key,
            'dateEtape': startdate,
          };
          referenceEtape.child(key).update(update_etape);
        }
      });
    });

    await referenceTotalInformation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> information = snapshot.value;
      information.forEach((key, values) {
        Map<String, String> totalInformation = {
          'nombredePlanning':
              (int.parse(values['nombredePlanning']) + 1).toString(),
        };
        referenceTotalInformation.child(key).update(totalInformation);
      });
    });
  }
}
