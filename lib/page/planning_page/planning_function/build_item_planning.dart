import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/trash/build_collecteur_part_planning.dart';
import 'package:tn09_app_demo/trash/build_etape_planning.dart';
import 'package:tn09_app_demo/trash/build_vehicule_part_planning.dart';

class buildItemPlanning extends StatefulWidget {
  BuildContext context;
  Map planning;
  buildItemPlanning({required this.context, required this.planning});
  @override
  _buildItemPlanningState createState() => _buildItemPlanningState();
}

class _buildItemPlanningState extends State<buildItemPlanning> {
  List<String> listNomLocationEtape = [];
  List<String> listAddressLocationEtape = [];
  List<String> listMaterialEtape = [];
  List<String> listNombredebacEtape = [];
  List<Widget> listWidget = [];
  String nomCollecteur = '';
  String prenomCollecteur = '';
  String typeVehicule = '';
  String numeroimmatriculation = '';

  Future<List<String>> futureWait() async {
    return Future.wait([
      Future.delayed(
          const Duration(seconds: 1), () => getInformationCollecteur()),
      Future.delayed(
          const Duration(seconds: 1), () => getInformationVehicule()),
      Future.delayed(const Duration(seconds: 1), () => getInformationEtape()),
    ]);
  }

  getInformationEtape() async {
    DatabaseReference _refEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    String etape_key = widget.planning['startetape_key'];
    int numberofEtape = int.parse(widget.planning['nombredeEtape']);
    for (int i = 0; i < numberofEtape; i++) {
      await _refEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> planning = snapshot.value;
        planning.forEach((key, values) {
          if (key == etape_key) {
            listNomLocationEtape.add(values['nomLocationEtape']);
            listAddressLocationEtape.add(values['addressLocationEtape']);
            listMaterialEtape.add(values['materialEtape']);
            listNombredebacEtape.add(values['nombredebac']);
            etape_key = values['afterEtape_key'];
          }
        });
      });
    }
    print('$listNomLocationEtape');
  }

  getInformationCollecteur() async {
    DatabaseReference _refCollecteur =
        FirebaseDatabase.instance.reference().child('Collecteur');
    await _refCollecteur.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == widget.planning['collecteur_key']) {
          nomCollecteur = values['nomCollecteur'];
          prenomCollecteur = values['prenomCollecteur'];
        }
      });
    });
  }

  getInformationVehicule() async {
    DatabaseReference _refVehicule =
        FirebaseDatabase.instance.reference().child('Vehicule');
    await _refVehicule.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == widget.planning['vehicule_key']) {
          typeVehicule = values['typeVehicule'];
          numeroimmatriculation = values['numeroimmatriculation'];
        }
      });
    });
  }

  List<Widget> buildInformation() {
    print('$listNomLocationEtape');
    int numberofEtape = int.parse(widget.planning['nombredeEtape']);
    print('$numberofEtape');
    for (int i = 0; i < listNomLocationEtape.length; i++) {
      listWidget.add(new Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.green,
          width: 2,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                  listNomLocationEtape[i],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
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
                  listAddressLocationEtape[i],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.restore_from_trash,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  listMaterialEtape[i],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.restore_from_trash,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  listNombredebacEtape[i],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    getInformationCollecteur();
    getInformationVehicule();
    getInformationEtape();
    return FutureBuilder<List<String>>(
      future: futureWait(),
      builder: (context, snapshot) {
        print('$snapshot');
        if (listNomLocationEtape != [] &&
                listNombredebacEtape != [] &&
                listAddressLocationEtape != [] &&
                listMaterialEtape != [] &&
                nomCollecteur != '' &&
                prenomCollecteur != '' &&
                typeVehicule != '' &&
                numeroimmatriculation != ''
            //have to change this check in the future
            ) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.blueAccent,
              width: 5,
            )),
            child: Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      widget.planning['startdate'],
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateCollecteur(
                            collecteurKey: collecteur['key'])));
                */
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Delete Planning',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateCollecteur(
                            collecteurKey: collecteur['key'])));
                */
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Copy Planning',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateCollecteur(
                            collecteurKey: collecteur['key'])));
                */
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Edit Planning',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateCollecteur(
                            collecteurKey: collecteur['key'])));
                */
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Edit Start Date',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      prenomCollecteur + '  ' + nomCollecteur,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () {
                        /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateCollecteur(
                            collecteurKey: collecteur['key'])));
                */
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Edit Collecteur',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.car_rental,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      typeVehicule + '  ' + numeroimmatriculation,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () {
                        /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Updatevehicule(
                            vehiculeKey: vehicule['key'])));
                */
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Edit Vehicule',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                    height: 250, child: ListView(children: buildInformation())),
                Divider(color: Colors.black),
              ],
            )),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
