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
import 'package:tn09_app_demo/page/etape_page/etape_function/build_choice_location_etape.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/show_etape.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/choice_vehicule_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/finish_planning.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class ConfirmEtape extends StatefulWidget {
  Map location;
  String reason;
  String numberofEtape;
  ConfirmEtape(
      {required this.location,
      required this.reason,
      required this.numberofEtape});
  @override
  _ConfirmEtapeState createState() => _ConfirmEtapeState();
}

class _ConfirmEtapeState extends State<ConfirmEtape> {
  final _etapeKeyForm = GlobalKey<FormState>();
  String material_Etape = 'biodechet';
  List<String> listmaterial = ['biodechet', 'papier', 'verre'];
  TextEditingController _numberofbac = TextEditingController();
  TextEditingController _noteEtape = TextEditingController();
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');

  Query _refLocation = FirebaseDatabase.instance
      .reference()
      .child('Location')
      .orderByChild('nomeLocation');

  String title = '';
  Widget setTitle() {
    if (widget.reason == 'confirmEtape') {
      return Text('Confirm Creaation Etape');
    } else {
      return Text('Creating Planning...');
    }
  }

  bool checkProgression() {
    if (widget.reason == 'confirmEtape') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: setTitle(),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          height: double.infinity,
          child: Form(
            key: _etapeKeyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                        'Nom de la Location: ' + widget.location['nomLocation'],
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600))
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.restore_from_trash,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Material: ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 6,
                    ),
                    DropdownButton(
                        value: material_Etape,
                        items: listmaterial.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text('$item'),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            material_Etape = value.toString();
                          });
                        },
                        hint: Text("Select type of material")),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.restore_from_trash_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Number of Bac: ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 6,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: _numberofbac,
                    decoration: const InputDecoration(
                      hintText: 'Number of Bac',
                    ),
                    validator: (value) {
                      if (value == null ||
                          isNumericUsing_tryParse(value) == false ||
                          value.isEmpty) {
                        return 'Please enter a real number';
                      }
                    },
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.sticky_note_2,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Note: ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 6,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: _noteEtape,
                    decoration: const InputDecoration(
                      hintText: 'Note',
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Visibility(
                    visible: checkProgression(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                        child: Text(
                          'Créer Etape',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          if (_etapeKeyForm.currentState!.validate()) {
                            SaveEtape(state: widget.reason);
                          }
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
                Visibility(
                    visible: !checkProgression(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                        child: Text(
                          'Continue?',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          if (_etapeKeyForm.currentState!.validate()) {
                            SaveEtape(state: 'continuePlanning');
                          }
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
                SizedBox(
                  height: 25,
                ),
                Visibility(
                    visible: !checkProgression(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                        child: Text(
                          'End?',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          if (_etapeKeyForm.currentState!.validate()) {
                            SaveEtape(state: 'endPlanning');
                          }
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  void SaveEtape({required String state}) async {
    String nomLocationEtape = widget.location['nomLocation'];
    String addressLocationEtape = widget.location['addressLocation'];
    String location_key = widget.location['key'];
    String contact_key = widget.location['contact_key'];
    String materialEtape = material_Etape;
    String nombredebac = _numberofbac.text;
    String noteEtape = _noteEtape.text;
    String beforeEtape_key = '';
    String afterEtape_key = '';
    String startEtape_key = '';

    if (state == 'confirmEtape') {
      beforeEtape_key = 'null';
      afterEtape_key = 'null';
      Map<String, String> etape = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'false',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': afterEtape_key,
      };

      referenceEtape.push().set(etape).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowEtape()),
        );
      });
    } else if (widget.reason == 'createPlanning' &&
        state == 'continuePlanning') {
      beforeEtape_key = 'start';
      afterEtape_key = 'wait';
      String numberofEtape = widget.numberofEtape;
      numberofEtape = (int.parse(numberofEtape) + 1).toString();
      Map<String, String> etape = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'false',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': afterEtape_key,
      };

      referenceEtape.push().set(etape).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateEtape(
                    reason: 'continuePlanning',
                    numberofEtape: numberofEtape,
                  )),
        );
      });
    } else if (widget.reason == 'createPlanning' && state == 'endPlanning') {
      beforeEtape_key = 'start';
      afterEtape_key = 'null';
      Map<String, String> etape = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'false',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': afterEtape_key,
      };

      referenceEtape.push().set(etape);

      DatabaseReference _refEndEtape =
          FirebaseDatabase.instance.reference().child('Etape');
      await _refEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['beforeEtape_key'] == 'start') {
            print('Into If right');
            startEtape_key = key;
            Map<String, String> planning = {
              'startetape_key': startEtape_key,
              'finished_create': 'false',
              'nombredeEtape': (int.parse(widget.numberofEtape) + 1).toString(),
            };
            FirebaseDatabase.instance
                .reference()
                .child('Planning')
                .push()
                .set(planning);
            Map<String, String> endetape = {
              'beforeEtape_key': 'null',
            };
            referenceEtape.child(key).update(endetape).then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChoiceVehiculePlanning(
                          reason: 'createPlanning',
                        )),
              );
            });
          }
        });
      });
    } else if (state == 'continuePlanning') {
      String numberofEtape = widget.numberofEtape;
      numberofEtape = (int.parse(numberofEtape) + 1).toString();
      DatabaseReference _refContinueEtape =
          FirebaseDatabase.instance.reference().child('Etape');
      await _refContinueEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            beforeEtape_key = key;
          }
        });
      });
      Map<String, String> newetape_1 = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'false',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': 'waitting'
      };

      referenceEtape.push().set(newetape_1);

      await _refContinueEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            afterEtape_key = key;
          }
        });
      });
      await _refContinueEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            Map<String, String> oldetape = {
              'afterEtape_key': afterEtape_key,
            };
            referenceEtape.child(key).update(oldetape);
          }
        });
      });
      await _refContinueEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            Map<String, String> newetape_2 = {
              'afterEtape_key': 'wait',
            };
            referenceEtape.child(key).update(newetape_2).then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateEtape(
                          reason: 'continuePlanning',
                          numberofEtape: numberofEtape,
                        )),
              );
            });
          }
        });
      });
    } else if (state == 'endPlanning') {
      DatabaseReference _refEndEtape =
          FirebaseDatabase.instance.reference().child('Etape');
      await _refEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            beforeEtape_key = key;
          }
        });
      });
      Map<String, String> newetape_1 = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'false',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': 'waitting'
      };

      referenceEtape.push().set(newetape_1);

      await _refEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            afterEtape_key = key;
          }
        });
      });
      await _refEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            Map<String, String> oldetape = {
              'afterEtape_key': afterEtape_key,
            };
            referenceEtape.child(key).update(oldetape);
          }
        });
      });
      await _refEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            Map<String, String> newetape_2 = {
              'afterEtape_key': 'null',
            };
            referenceEtape.child(key).update(newetape_2);
          }
        });
      });
      await _refEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['beforeEtape_key'] == 'start') {
            print('Into If right');
            startEtape_key = key;
            Map<String, String> planning = {
              'startetape_key': startEtape_key,
              'finished_create': 'false',
              'nombredeEtape': (int.parse(widget.numberofEtape) + 1).toString(),
            };
            Map<String, String> endetape = {
              'beforeEtape_key': 'null',
            };
            referenceEtape.child(key).update(endetape);
            FirebaseDatabase.instance
                .reference()
                .child('Planning')
                .push()
                .set(planning)
                .then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChoiceVehiculePlanning(reason: 'createPlanning')),
              );
            });
          }
        });
      });
    }
  }
}
