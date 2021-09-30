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
import 'package:tn09_app_demo/page/etape_page/etape_function/confirm_etape.dart';
import 'package:tn09_app_demo/page/location_page/location_function/search_location.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class CreateEtape extends StatefulWidget {
  String reason;
  String numberofEtape;
  CreateEtape({required this.reason, required this.numberofEtape});
  @override
  _CreateEtapeState createState() => _CreateEtapeState();
}

class _CreateEtapeState extends State<CreateEtape> {
  Query _refLocation = FirebaseDatabase.instance
      .reference()
      .child('Location')
      .orderByChild('nomeLocation');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');

  Widget setTitle() {
    if (widget.reason == 'createEtape') {
      return Text('Creér Etape');
    } else {
      return Text('Creating Planning...');
    }
  }

  Future<bool?> dialogDecide(BuildContext context) async {
    if (widget.reason == 'confirmEtape' || widget.reason == 'createEtape') {
      return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Cancel Create New Etape?'),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  )
                ],
              ));
    } else {
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
  }

  Future<List<String>> futureWait() async {
    return Future.wait([
      Future.delayed(const Duration(seconds: 1), () => getNumberofLocation()),
      Future.delayed(
          const Duration(seconds: 2), () => getInformationLocation()),
    ]);
  }

  int numberofLocation = 0;
  getNumberofLocation() async {
    if (numberofLocation > 0) {
      return;
    }
    await referenceTotalInformation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> information = snapshot.value;
      information.forEach((key, values) {
        numberofLocation = int.parse(values['nombredeLocation']);
      });
    });
    await referenceLocation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> information = snapshot.value;
      information.forEach((key, values) {
        if (values['showed'] == 'true') {
          numberofLocation--;
        }
      });
    });
  }

  List<String> listNomLocation = [];

  getInformationLocation() {
    DatabaseReference _refLocation =
        FirebaseDatabase.instance.reference().child('Location');

    if (listNomLocation.length < numberofLocation) {
      for (int i = 0; i < numberofLocation; i++) {
        _refLocation.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> location = snapshot.value;
          location.forEach((key, values) {
            if (values['showed'] == 'false') {
              if (!listNomLocation.contains(values['nomLocation'])) {
                listNomLocation.add(values['nomLocation']);
              }
            }
          });
        });
      }
      return listNomLocation;
    } else {
      return listNomLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    getNumberofLocation();
    getInformationLocation();
    //print('ListNomLocation before fururebuild: $listNomLocation');
    //print('listLocation lenght : ${listLocation.length}');
    //print('numberofLocation $numberofLocation');
    //print('$listLocation');
    return FutureBuilder<List<String>>(
      future: futureWait(),
      builder: (context, snapshot) {
        if (listNomLocation != []) {
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
                    if (widget.reason == 'createPlanning' ||
                        widget.reason == 'continuePlanning') {
                      deleteCreatingPlanningProcess();
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                title: setTitle(),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      //print('list NomLocation before send $listNomLocation');
                      listNomLocation =
                          getInformationLocation().toSet().toList();
                      if (listNomLocation != []) {
                        showSearch(
                            context: context,
                            delegate: LocationSearch(
                                reason: widget.reason,
                                numberofEtape: widget.numberofEtape,
                                listNomLocation: listNomLocation));
                      } else {
                        const Center(child: CircularProgressIndicator());
                      }

                      // final results = await
                      //     showSearch(context: context, delegate: CitySearch());

                      // print('Result: $results');
                    },
                  )
                ],
              ),
              /*body: Center(
        child: DropdownButton<String>(
          items: createList().map(buildMenuItem).toList(),
          onChanged: (value) => setState(() => this.value = value),
        ),
      ),*/
              body: Container(
                height: double.infinity,
                child: FirebaseAnimatedList(
                  query: _refLocation,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map location = snapshot.value;
                    location['key'] = snapshot.key;
                    if (location['showed'] == 'false') {
                      return buildChoiceLocation(
                          context: context,
                          location: location,
                          reason: widget.reason,
                          numberofEtape: widget.numberofEtape);
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
