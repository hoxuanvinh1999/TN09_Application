import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';

class UpdateEtape extends StatefulWidget {
  String etapeKey;

  UpdateEtape({required this.etapeKey});

  @override
  _UpdateEtapeState createState() => _UpdateEtapeState();
}

class _UpdateEtapeState extends State<UpdateEtape> {
  final _etapeKeyForm = GlobalKey<FormState>();
  String material_Etape = 'biodechet';
  List<String> listmaterial = ['biodechet', 'papier', 'verre'];
  TextEditingController _numberofbac = TextEditingController();
  TextEditingController _noteEtape = TextEditingController();
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Etape'),
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
                      'Update Etape',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_etapeKeyForm.currentState!.validate()) {
                        UpdateEtape();
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

  void UpdateEtape() async {
    DatabaseReference _refEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    Map<String, String> etape = {
      'materialEtape': material_Etape,
      'nombredebac': _numberofbac.text,
      'noteEtape': _noteEtape.text,
    };
    await _refEtape.child(widget.etapeKey).update(etape).then((value) {
      Navigator.pop(context);
    });
  }
}
