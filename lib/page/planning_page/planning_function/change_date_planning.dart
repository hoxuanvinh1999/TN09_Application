import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class ChangeDatePlanning extends StatefulWidget {
  String planningKey;

  ChangeDatePlanning({required this.planningKey});

  @override
  _ChangeDatePlanningState createState() => _ChangeDatePlanningState();
}

class _ChangeDatePlanningState extends State<ChangeDatePlanning> {
  final _planningKeyForm = GlobalKey<FormState>();

  DatabaseReference _refPlanning =
      FirebaseDatabase.instance.reference().child('Planning');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Date Planning'),
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
                      'Change Date Planning',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_planningKeyForm.currentState!.validate()) {
                        updateDatePlanning();
                      }
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          )),
    );
  }

  void updateDatePlanning() async {
    String startdate = DateFormat('yMd').format(date).toString();
    DatabaseReference _refEtape =
        FirebaseDatabase.instance.reference().child('Planning');
    Map<String, String> etape = {
      'startdate': startdate,
    };
    await _refEtape.child(widget.planningKey).update(etape).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlanningPage()),
      );
    });
  }
}
