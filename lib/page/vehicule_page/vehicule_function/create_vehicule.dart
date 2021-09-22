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
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class CreateVehicule extends StatefulWidget {
  @override
  _CreateVehiculeState createState() => _CreateVehiculeState();
}

class _CreateVehiculeState extends State<CreateVehicule> {
  final _vehiculeKeyForm = GlobalKey<FormState>();
  String type_vehicule = 'velo';
  String state_vehicule = '5';
  List<String> listTypeVehicule = ['velo', 'camion'];
  List<String> listStateVehicule = ['0', '1', '2', '3', '4', '5'];
  TextEditingController _numeroImmatriculation = TextEditingController();
  TextEditingController _maxweightVehicule = TextEditingController();
  DatabaseReference referenceVehicule =
      FirebaseDatabase.instance.reference().child('Vehicule');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer Vehicule'),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          height: double.infinity,
          child: Form(
            key: _vehiculeKeyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.car_rental,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Type du vehicule: ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 6,
                    ),
                    DropdownButton(
                        value: type_vehicule,
                        items: listTypeVehicule.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text('$item'),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            type_vehicule = value.toString();
                          });
                        },
                        hint: Text("Select type of vehicule")),
                  ],
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _numeroImmatriculation,
                  decoration: InputDecoration(
                    hintText: 'Numero immatriculation',
                    prefixIcon: Icon(
                      Icons.directions_car,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a something';
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _maxweightVehicule,
                  decoration: InputDecoration(
                    hintText: 'Max Weight',
                    prefixIcon: Icon(
                      Icons.settings_applications,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.parse(value) <= 0) {
                      return 'Please enter number positive';
                    }
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.car_rental,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('State: ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 6,
                    ),
                    DropdownButton(
                        value: state_vehicule,
                        items: listStateVehicule.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text('$item'),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            state_vehicule = value.toString();
                          });
                        },
                        hint: Text("Select state of vehicule")),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    child: Text(
                      'Créer Vehicule',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_vehiculeKeyForm.currentState!.validate()) {
                        SaveVehicule();
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

  void SaveVehicule() async {
    String numeroimmatriculation = _numeroImmatriculation.text;
    String typeVehicule = type_vehicule;
    String maxWeightVehicule = _maxweightVehicule.text;
    String stateVehicule = state_vehicule;

    Map<String, String> vehicule = {
      'numeroimmatriculation': numeroimmatriculation,
      'typeVehicule': typeVehicule,
      'maxWeightVehicule': maxWeightVehicule,
      'stateVehicule': stateVehicule,
    };
    await referenceTotalInformation.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> etape = snapshot.value;
      etape.forEach((key, values) {
        Map<String, String> totalInformation = {
          'nombredeVehicule':
              (int.parse(values['nombredeVehicule']) + 1).toString(),
        };
        referenceTotalInformation.child(key).update(totalInformation);
      });
    });
    referenceVehicule.push().set(vehicule).then((value) {
      Navigator.pop(context);
    });
  }
}
