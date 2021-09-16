import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class buildVehiculePlanning extends StatefulWidget {
  String vehicule_key;
  BuildContext context;
  buildVehiculePlanning({required this.context, required this.vehicule_key});
  @override
  _buildVehiculePlanningState createState() => _buildVehiculePlanningState();
}

class _buildVehiculePlanningState extends State<buildVehiculePlanning> {
  String numeroimmatriculation = '';
  String typeVehicule = '';
  @override
  Widget build(BuildContext context) => buildInformation(
      context: widget.context, Vehicule_key: widget.vehicule_key);

  Widget buildInformation(
      {required BuildContext context, required String Vehicule_key}) {
    getInformation();
    return Container(
      height: 80,
      color: Colors.white,
      child: Column(
        children: [
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
        ],
      ),
    );
  }

  getInformation() async {
    DatabaseReference _refVehicule =
        FirebaseDatabase.instance.reference().child('Vehicule');
    await _refVehicule.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == widget.vehicule_key) {
          typeVehicule = values['typeVehicule'];
          numeroimmatriculation = values['numeroimmatriculation'];
        }
      });
    });
  }
}
