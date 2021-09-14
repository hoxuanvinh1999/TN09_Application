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
import 'package:tn09_app_demo/widget/button_widget.dart';

class ConfirmEtape extends StatefulWidget {
  Map location;

  ConfirmEtape({required this.location});
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Creaation Etape'),
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
                Container(
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
                        SaveEtape();
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

  void SaveEtape() {
    String nomLocationEtape = widget.location['nomLocation'];
    String addressLocationEtape = widget.location['addressLocation'];
    String location_key = widget.location['key'];
    String materialEtape = material_Etape;
    String nombredebac = _numberofbac.text;
    String noteEtape = _noteEtape.text;

    Map<String, String> etape = {
      'nomLocationEtape': nomLocationEtape,
      'addressLocationEtape': addressLocationEtape,
      'location_key': location_key,
      'materialEtape': materialEtape,
      'nombredebac': nombredebac,
      'checked': 'false',
      'reason_not_checked': '',
      'noteEtape': noteEtape,
      'dateEtape': '',
    };

    referenceEtape.push().set(etape).then((value) {
      Navigator.pop(context);
    });
  }
}
