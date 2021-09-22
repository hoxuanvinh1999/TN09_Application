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
    if (widget.reason == 'confirmEtape') {
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

  int numberofLocation = 0;

  Future<List<String>> futureWait() async {
    return Future.wait([
      Future.delayed(const Duration(seconds: 1), () => getNumberofLocation()),
      Future.delayed(
          const Duration(seconds: 1), () => getInformationLocation()),
    ]);
  }

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

  List<Map<String, String>> listLocation = [];
  List<String> listNomLocation = [];

  getInformationLocation() {
    //print('numberofLocation: $numberofLocation');
    DatabaseReference _refLocation =
        FirebaseDatabase.instance.reference().child('Location');

    if (listLocation.length < numberofLocation ||
        listNomLocation.length < numberofLocation) {
      for (int i = 0; i < numberofLocation; i++) {
        _refLocation.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> location = snapshot.value;
          location.forEach((key, values) {
            if (values['showed'] == 'false') {
              //print('ListNomLocation: $listNomLocation');
              //print('listLocation lenght : ${listLocation.length}');
              //print('numberofLocation $numberofLocation');
              Map<String, String> itemLocation = {
                'key': key,
                'nombredebac': values['nombredebac'],
                'contact_key': values['contact_key'],
                'nomLocation': values['nomLocation'],
                'addressLocation': values['addressLocation'],
                'type': values['type'],
                'nombredecle': values['nombredecle'],
                'showed': values['showed'],
              };
              if (!listLocation.contains(itemLocation)) {
                listNomLocation.add(values['nomLocation']);
              }
              if (!listNomLocation.contains(values['nomLocation'])) {
                listLocation.add(itemLocation);
              }
            }
          });
        });
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    getNumberofLocation();
    getInformationLocation();
    //print('ListNomLocation: $listNomLocation');
    //print('listLocation lenght : ${listLocation.length}');
    //print('numberofLocation $numberofLocation');
    //print('$listLocation');
    return FutureBuilder<List<String>>(
      future: futureWait(),
      builder: (context, snapshot) {
        if (listLocation != [] && listNomLocation != []) {
          return WillPopScope(
            onWillPop: () async {
              final goback = await dialogDecide(context);
              return goback ?? false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: setTitle(),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      print('List Location before send $listLocation');
                      print('list NomLocation before send $listNomLocation');
                      showSearch(
                          context: context,
                          delegate: LocationSearch(
                              reason: widget.reason,
                              numberofEtape: widget.numberofEtape,
                              listLocation: listLocation.toSet().toList(),
                              listNomLocation:
                                  listNomLocation.toSet().toList()));

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

class LocationSearch extends SearchDelegate<String> {
  String reason;
  String numberofEtape;
  List<Map<String, String>> listLocation;
  List<String> listNomLocation;
  LocationSearch({
    required this.reason,
    required this.numberofEtape,
    required this.listLocation,
    required this.listNomLocation,
  });
  int position = 0;

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? listNomLocation
        : listNomLocation.where((choice) {
            final choiceLower = choice.toLowerCase();
            final queryLower = query.toLowerCase();

            return choice.startsWith(queryLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () async {
              query = suggestion;
              print('$query');
              position = listNomLocation.indexOf(query);
              print(' position: $position');
              print('$listLocation');
              DatabaseReference referenceLocation =
                  FirebaseDatabase.instance.reference().child('Location');
              for (int i = 0; i < listNomLocation.length; i++) {
                await referenceLocation.once().then((DataSnapshot snapshot) {
                  Map<dynamic, dynamic> location = snapshot.value;
                  location.forEach((key, values) {
                    if (values['showed'] == 'false') {
                      //print('ListNomLocation: $listNomLocation');
                      //print('listLocation lenght : ${listLocation.length}');
                      //print('numberofLocation $numberofLocation');
                      Map<String, String> itemLocation = {
                        'key': key,
                        'nombredebac': values['nombredebac'],
                        'contact_key': values['contact_key'],
                        'nomLocation': values['nomLocation'],
                        'addressLocation': values['addressLocation'],
                        'type': values['type'],
                        'nombredecle': values['nombredecle'],
                        'showed': values['showed'],
                      };
                      listLocation.add(itemLocation);
                    }
                  });
                });
              }
              print('$listLocation');
              //print('$listNomLocation');
              // 1. Show Results
              //showResults(context);

              // 2. Close Search & Return Result
              // close(context, suggestion);

              //3. Navigate to Result Page
              if (reason == 'createEtape') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ConfirmEtape(
                      location: listLocation[position],
                      reason: 'confirmEtape',
                      numberofEtape: 'null',
                    );
                  }),
                );
              } else if (reason == 'createPlanning') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ConfirmEtape(
                      location: listLocation[position],
                      reason: 'createPlanning',
                      numberofEtape: numberofEtape,
                    );
                  }),
                );
              } else if (reason == 'continuePlanning') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ConfirmEtape(
                      location: listLocation[position],
                      reason: 'continuePlanning',
                      numberofEtape: numberofEtape,
                    );
                  }),
                );
              } else {
                updateLocationEtape(
                    location: listLocation[position], etapeKey: reason);
                Navigator.pop(context);
              }
            },
            leading: Icon(Icons.home),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
