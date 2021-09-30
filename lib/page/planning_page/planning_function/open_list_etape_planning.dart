import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/build_item_contact.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_item_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/search_etape.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_choice_etape_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/blocs/application_bloc.dart';

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
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  Future<List<String>> futureWait() async {
    return Future.wait([
      Future.delayed(const Duration(seconds: 1), () => getNumberofEtape()),
      Future.delayed(const Duration(seconds: 2), () => getInformationEtape()),
    ]);
  }

  int numberofEtape = 0;
  getNumberofEtape() async {
    if (numberofEtape > 0) {
      return;
    }
    await referenceTotalInformation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> information = snapshot.value;
      information.forEach((key, values) {
        numberofEtape = int.parse(values['nombredeLocation']);
      });
    });
    await referenceEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        if (values['showed'] == 'true') {
          numberofEtape--;
        }
      });
    });
  }

  List<String> listNomEtape = [];

  getInformationEtape() {
    DatabaseReference _refEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    if (listNomEtape.length < numberofEtape) {
      for (int i = 0; i < numberofEtape; i++) {
        _refEtape.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> location = snapshot.value;
          location.forEach((key, values) {
            if (values['showed'] == 'false') {
              listNomEtape.add(values['nomLocationEtape']);
            }
          });
        });
      }
      return listNomEtape;
    } else {
      return listNomEtape;
    }
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
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    getNumberofEtape();
    getInformationEtape();
    //print('nombre de Etape $numberofEtape');
    //print('ListNomEtape $listNomEtape');
    return FutureBuilder<List<String>>(
        future: futureWait(),
        builder: (context, snapshot) {
          if (listNomEtape != []) {
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                    ),
                    title: Text('List Etape'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          //print('list NomEtape before send $listNomEtape');
                          listNomEtape = getInformationEtape().toSet().toList();
                          if (listNomEtape != []) {
                            showSearch(
                                context: context,
                                delegate: EtapeSearch(
                                    context: context,
                                    reason: widget.reason,
                                    numberofEtape: widget.numberofEtape,
                                    listNomEtape:
                                        listNomEtape.toSet().toList()));
                          } else {
                            const Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    ],
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
          return const Center(child: CircularProgressIndicator());
        });
  }
}
