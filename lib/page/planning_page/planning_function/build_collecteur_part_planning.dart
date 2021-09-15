import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class buildCollecteurPlanning extends StatefulWidget {
  String collecteur_key;
  BuildContext context;
  buildCollecteurPlanning(
      {required this.context, required this.collecteur_key});
  @override
  _buildCollecteurPlanningState createState() =>
      _buildCollecteurPlanningState();
}

class _buildCollecteurPlanningState extends State<buildCollecteurPlanning> {
  String nomCollecteur = '';
  String prenomCollecteur = '';
  @override
  Widget build(BuildContext context) => buildInformation(
      context: widget.context, collecteur_key: widget.collecteur_key);

  Widget buildInformation(
      {required BuildContext context, required String collecteur_key}) {
    getInformation();
    return Container(
      height: 80,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  getInformation() async {
    DatabaseReference _refCollecteur =
        FirebaseDatabase.instance.reference().child('Collecteur');
    await _refCollecteur.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == widget.collecteur_key) {
          nomCollecteur = values['nomCollecteur'];
          prenomCollecteur = values['prenomCollecteur'];
        }
      });
    });
  }
}
