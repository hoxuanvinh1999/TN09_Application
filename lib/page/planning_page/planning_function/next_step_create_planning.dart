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
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/search_etape.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/choice_vehicule_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/open_list_etape_planning.dart';

class NextStepCreatePlanning extends StatefulWidget {
  Map etape;
  String reason;
  String numberofEtape;
  BuildContext context;
  NextStepCreatePlanning(
      {required this.etape,
      required this.reason,
      required this.numberofEtape,
      required this.context});
  @override
  _NextStepCreatePlanningState createState() => _NextStepCreatePlanningState();
}

class _NextStepCreatePlanningState extends State<NextStepCreatePlanning> {
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
          title: Text('Next Step...'),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  child: Text(
                    'Continue with new Etape',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    nextStep(
                        context: context,
                        etape: widget.etape,
                        numberofEtape: widget.numberofEtape,
                        state: 'newEtape',
                        reason: widget.reason);
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  child: Text(
                    'Continue with avalable Etape',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    nextStep(
                        context: context,
                        etape: widget.etape,
                        numberofEtape: widget.numberofEtape,
                        state: 'availableEtape',
                        reason: widget.reason);
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  child: Text(
                    'End Planning',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    nextStep(
                        context: context,
                        etape: widget.etape,
                        numberofEtape: widget.numberofEtape,
                        state: 'endPlanning',
                        reason: widget.reason);
                  },
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void nextStep(
    {required BuildContext context,
    required Map etape,
    required numberofEtape,
    required state,
    required reason}) async {
  String beforeEtape_key = '';
  String afterEtape_key = '';
  String startEtape_key = '';
  String number_Etape = '';
  int i = 0;
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  if (reason == 'createPlanning' && state != 'endPlanning') {
    print('$reason  $state');
    DatabaseReference referenceEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    DatabaseReference referenceLocation =
        FirebaseDatabase.instance.reference().child('Location');
    if (state == 'newEtape') {
      await referenceLocation.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_location = snapshot.value;
        check_location.forEach((key, values) {
          if (values['showed'] == 'false') {
            i++;
          }
        });
      });
    }
    if (state == 'availableEtape') {
      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (values['showed'] == 'false') {
            i++;
          }
        });
      });
    }
    print('i= $i');
    if (i == 1) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('We used all location or Etape available, finish?'),
                actions: [
                  ElevatedButton(
                    child: Text('Ok'),
                    onPressed: () async {
                      DatabaseReference referenceEtape =
                          FirebaseDatabase.instance.reference().child('Etape');
                      beforeEtape_key = 'start';
                      afterEtape_key = 'null';
                      Map<String, String> new_etape = {
                        'nomLocationEtape': etape['nomLocationEtape'],
                        'addressLocationEtape': etape['addressLocationEtape'],
                        'location_key': etape['location_key'],
                        'contact_key': etape['contact_key'],
                        'materialEtape': etape['materialEtape'],
                        'nombredebac': etape['nombredebac'],
                        'checked': 'creating',
                        'reason_not_checked': '',
                        'noteEtape': etape['noteEtape'],
                        'dateEtape': '',
                        'beforeEtape_key': beforeEtape_key,
                        'afterEtape_key': afterEtape_key,
                        'showed': 'true',
                      };

                      referenceEtape.push().set(new_etape);

                      await referenceTotalInformation
                          .once()
                          .then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> etape = snapshot.value;
                        etape.forEach((key, values) {
                          Map<String, String> totalInformation = {
                            'nombredeEtape':
                                (int.parse(values['nombredeEtape']) +
                                        int.parse(numberofEtape) +
                                        1)
                                    .toString(),
                          };
                          referenceTotalInformation
                              .child(key)
                              .update(totalInformation);
                        });
                      });

                      await referenceEtape.once().then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> check_etape = snapshot.value;
                        check_etape.forEach((key, values) {
                          if (values['beforeEtape_key'] == 'start') {
                            print('Into If right');
                            startEtape_key = key;
                            Map<String, String> planning = {
                              'startetape_key': startEtape_key,
                              'finished_create': 'false',
                              'nombredeEtape':
                                  (int.parse(numberofEtape) + 1).toString(),
                            };
                            FirebaseDatabase.instance
                                .reference()
                                .child('Planning')
                                .push()
                                .set(planning);
                            Map<String, String> endetape = {
                              'beforeEtape_key': 'null',
                            };
                            referenceEtape.child(key).update(endetape);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChoiceVehiculePlanning(
                                        reason: 'createPlanning',
                                      )),
                            );
                          }
                        });
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text('Cancel planning'),
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
    } else {
      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (etape['key'] == key) {
            print('into if right');
            Map<String, String> update_etape = {
              'showed': 'true',
            };
            referenceEtape.child(key).update(update_etape);
          }
          if (values['nomLocationEtape'] == etape['nomLocationEtape'] &&
              values['addressLocationEtape'] == etape['addressLocationEtape']) {
            Map<String, String> update_etape = {
              'showed': 'true',
            };
            referenceEtape.child(key).update(update_etape);
          }
        });
      });
      beforeEtape_key = 'start';
      afterEtape_key = 'wait';
      number_Etape = (int.parse(numberofEtape) + 1).toString();
      Map<String, String> new_etape = {
        'nomLocationEtape': etape['nomLocationEtape'],
        'addressLocationEtape': etape['addressLocationEtape'],
        'location_key': etape['location_key'],
        'contact_key': etape['contact_key'],
        'materialEtape': etape['materialEtape'],
        'nombredebac': etape['nombredebac'],
        'checked': 'creating',
        'reason_not_checked': '',
        'noteEtape': etape['noteEtape'],
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': afterEtape_key,
        'showed': 'true',
      };

      referenceEtape.push().set(new_etape).then((value) {
        if (state == 'newEtape') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateEtape(
                      reason: 'continuePlanning',
                      numberofEtape: (int.parse(numberofEtape) + 1).toString(),
                    )),
          );
        } else if (state == 'availableEtape') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpenListEtape(
                      reason: 'continuePlanning',
                      numberofEtape: (int.parse(numberofEtape) + 1).toString(),
                    )),
          );
        }
      });
    }
  } else if (reason == 'createPlanning' && state == 'endPlanning') {
    DatabaseReference referenceEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    beforeEtape_key = 'start';
    afterEtape_key = 'null';
    Map<String, String> new_etape = {
      'nomLocationEtape': etape['nomLocationEtape'],
      'addressLocationEtape': etape['addressLocationEtape'],
      'location_key': etape['location_key'],
      'contact_key': etape['contact_key'],
      'materialEtape': etape['materialEtape'],
      'nombredebac': etape['nombredebac'],
      'checked': 'creating',
      'reason_not_checked': '',
      'noteEtape': etape['noteEtape'],
      'dateEtape': '',
      'beforeEtape_key': beforeEtape_key,
      'afterEtape_key': afterEtape_key,
      'showed': 'true',
    };

    referenceEtape.push().set(new_etape);

    await referenceTotalInformation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        Map<String, String> totalInformation = {
          'nombredeEtape': (int.parse(values['nombredeEtape']) +
                  int.parse(numberofEtape) +
                  1)
              .toString(),
        };
        referenceTotalInformation.child(key).update(totalInformation);
      });
    });

    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (values['beforeEtape_key'] == 'start') {
          print('Into If right');
          startEtape_key = key;
          Map<String, String> planning = {
            'startetape_key': startEtape_key,
            'finished_create': 'false',
            'nombredeEtape': (int.parse(numberofEtape) + 1).toString(),
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
          ;
        }
      });
    });
  } else if (reason == 'continuePlanning' && state != 'endPlanning') {
    DatabaseReference referenceEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    DatabaseReference referenceLocation =
        FirebaseDatabase.instance.reference().child('Location');
    if (state == 'newEtape') {
      await referenceLocation.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_location = snapshot.value;
        check_location.forEach((key, values) {
          if (values['showed'] == 'false') {
            i++;
          }
        });
      });
    }
    if (state == 'availableEtape') {
      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (values['showed'] == 'false') {
            i++;
          }
        });
      });
    }
    if (i == 1) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('We used all location or Etape available, finish?'),
                actions: [
                  ElevatedButton(
                    child: Text('Ok'),
                    onPressed: () async {
                      DatabaseReference referenceEtape =
                          FirebaseDatabase.instance.reference().child('Etape');
                      await referenceEtape.once().then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> check_etape = snapshot.value;
                        check_etape.forEach((key, values) {
                          if (values['afterEtape_key'] == 'wait') {
                            print('Into If right');
                            beforeEtape_key = key;
                          }
                        });
                      });
                      Map<String, String> newetape_1 = {
                        'nomLocationEtape': etape['nomLocationEtape'],
                        'addressLocationEtape': etape['addressLocationEtape'],
                        'location_key': etape['location_key'],
                        'contact_key': etape['contact_key'],
                        'materialEtape': etape['materialEtape'],
                        'nombredebac': etape['nombredebac'],
                        'checked': 'creating',
                        'reason_not_checked': '',
                        'noteEtape': etape['noteEtape'],
                        'dateEtape': '',
                        'beforeEtape_key': beforeEtape_key,
                        'afterEtape_key': 'waitting'
                      };

                      referenceEtape.push().set(newetape_1);

                      await referenceEtape.once().then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> check_etape = snapshot.value;
                        check_etape.forEach((key, values) {
                          if (values['afterEtape_key'] == 'waitting') {
                            print('Into If right');
                            afterEtape_key = key;
                          }
                        });
                      });
                      await referenceEtape.once().then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> check_etape = snapshot.value;
                        check_etape.forEach((key, values) {
                          if (values['afterEtape_key'] == 'wait') {
                            print('Into If right');
                            Map<String, String> oldetape = {
                              'afterEtape_key': afterEtape_key,
                            };
                            referenceEtape.child(key).update(oldetape);
                          }
                        });
                      });
                      await referenceEtape.once().then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> check_etape = snapshot.value;
                        check_etape.forEach((key, values) {
                          if (values['afterEtape_key'] == 'waitting') {
                            print('Into If right');
                            Map<String, String> newetape_2 = {
                              'afterEtape_key': 'null',
                            };
                            referenceEtape.child(key).update(newetape_2);
                          }
                        });
                      });

                      await referenceTotalInformation
                          .once()
                          .then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> information = snapshot.value;
                        information.forEach((key, values) {
                          Map<String, String> totalInformation = {
                            'nombredeEtape':
                                (int.parse(values['nombredeEtape']) +
                                        int.parse(numberofEtape) +
                                        1)
                                    .toString(),
                          };
                          referenceTotalInformation
                              .child(key)
                              .update(totalInformation);
                        });
                      });

                      await referenceEtape.once().then((DataSnapshot snapshot) {
                        Map<dynamic, dynamic> check_etape = snapshot.value;
                        check_etape.forEach((key, values) {
                          if (values['beforeEtape_key'] == 'start') {
                            print('Into If right');
                            startEtape_key = key;
                            Map<String, String> planning = {
                              'startetape_key': startEtape_key,
                              'finished_create': 'false',
                              'nombredeEtape':
                                  (int.parse(numberofEtape) + 1).toString(),
                            };
                            Map<String, String> endetape = {
                              'beforeEtape_key': 'null',
                            };
                            referenceEtape.child(key).update(endetape);
                            FirebaseDatabase.instance
                                .reference()
                                .child('Planning')
                                .push()
                                .set(planning);
                          }
                        });
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChoiceVehiculePlanning(
                                  reason: 'createPlanning',
                                )),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Cancel planning'),
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
    } else {
      DatabaseReference referenceEtape =
          FirebaseDatabase.instance.reference().child('Etape');
      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (key == etape['key']) {
            Map<String, String> update_etape = {
              'showed': 'true',
            };
            referenceEtape.child(key).update(update_etape);
          }
          if (values['nomLocationEtape'] == etape['nomLocationEtape'] &&
              values['addressLocationEtape'] == etape['addressLocationEtape']) {
            Map<String, String> update_etape = {
              'showed': 'true',
            };
            referenceEtape.child(key).update(update_etape);
          }
        });
      });
      number_Etape = (int.parse(numberofEtape) + 1).toString();
      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            beforeEtape_key = key;
          }
        });
      });
      Map<String, String> newetape_1 = {
        'nomLocationEtape': etape['nomLocationEtape'],
        'addressLocationEtape': etape['addressLocationEtape'],
        'location_key': etape['location_key'],
        'contact_key': etape['contact_key'],
        'materialEtape': etape['materialEtape'],
        'nombredebac': etape['nombredebac'],
        'checked': 'creating',
        'reason_not_checked': '',
        'noteEtape': etape['noteEtape'],
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': 'waitting'
      };

      referenceEtape.push().set(newetape_1);

      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            afterEtape_key = key;
          }
        });
      });
      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            Map<String, String> oldetape = {
              'afterEtape_key': afterEtape_key,
            };
            referenceEtape.child(key).update(oldetape);
          }
        });
      });
      await referenceEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> check_etape = snapshot.value;
        check_etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            Map<String, String> newetape_2 = {
              'afterEtape_key': 'wait',
            };
            referenceEtape.child(key).update(newetape_2);
          }
        });
      });
      if (state == 'newEtape') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateEtape(
                    reason: 'continuePlanning',
                    numberofEtape: (int.parse(numberofEtape) + 1).toString(),
                  )),
        );
      } else if (state == 'availableEtape') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenListEtape(
                    reason: 'continuePlanning',
                    numberofEtape: (int.parse(numberofEtape) + 1).toString(),
                  )),
        );
      }
    }
  } else if (state == 'endPlanning') {
    DatabaseReference _refEndEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    DatabaseReference referenceEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    await _refEndEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (values['afterEtape_key'] == 'wait') {
          print('Into If right');
          beforeEtape_key = key;
        }
      });
    });
    print('before_key $beforeEtape_key');
    Map<String, String> newetape_1 = {
      'nomLocationEtape': etape['nomLocationEtape'],
      'addressLocationEtape': etape['addressLocationEtape'],
      'location_key': etape['location_key'],
      'contact_key': etape['contact_key'],
      'materialEtape': etape['materialEtape'],
      'nombredebac': etape['nombredebac'],
      'checked': 'creating',
      'reason_not_checked': '',
      'noteEtape': etape['noteEtape'],
      'dateEtape': '',
      'beforeEtape_key': beforeEtape_key,
      'afterEtape_key': 'waitting',
      'showed': 'true',
    };

    referenceEtape.push().set(newetape_1);

    await _refEndEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (values['afterEtape_key'] == 'waitting') {
          print('Into If right');
          afterEtape_key = key;
        }
      });
    });
    await _refEndEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
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
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (values['afterEtape_key'] == 'waitting') {
          print('Into If right');
          Map<String, String> newetape_2 = {
            'afterEtape_key': 'null',
          };
          referenceEtape.child(key).update(newetape_2);
        }
      });
    });

    await referenceTotalInformation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> information = snapshot.value;
      information.forEach((key, values) {
        Map<String, String> totalInformation = {
          'nombredeEtape': (int.parse(values['nombredeEtape']) +
                  int.parse(numberofEtape) +
                  1)
              .toString(),
        };
        referenceTotalInformation.child(key).update(totalInformation);
      });
    });

    await _refEndEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> check_etape = snapshot.value;
      check_etape.forEach((key, values) {
        if (values['beforeEtape_key'] == 'start') {
          print('Into If right');
          startEtape_key = key;
          Map<String, String> planning = {
            'startetape_key': startEtape_key,
            'finished_create': 'false',
            'nombredeEtape': (int.parse(numberofEtape) + 1).toString(),
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
