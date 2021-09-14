import 'dart:async';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class UpdateCollecteur extends StatefulWidget {
  String collecteurKey;

  UpdateCollecteur({required this.collecteurKey});

  @override
  _UpdateCollecteurState createState() => _UpdateCollecteurState();
}

class _UpdateCollecteurState extends State<UpdateCollecteur> {
  final _updateCollecteurKey = GlobalKey<FormState>();
  TextEditingController _lastnameCollecteur = TextEditingController();
  TextEditingController _firstnameCollecteur = TextEditingController();

  DatabaseReference _refCollecteur =
      FirebaseDatabase.instance.reference().child('Collecteur');

  DateTime date = DateTime.now();

  String getText({required DateTime date}) {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('MM/dd/yyyy').format(date);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year - 25),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (newDate == null) return;
    setState(() => date = newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Collecteur'),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          height: double.infinity,
          child: Form(
            key: _updateCollecteurKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _lastnameCollecteur,
                  decoration: InputDecoration(
                    hintText: 'Nom du Colllecteur',
                    prefixIcon: Icon(
                      Icons.person,
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
                  controller: _firstnameCollecteur,
                  decoration: InputDecoration(
                    hintText: 'Prenom du Collecteur',
                    prefixIcon: Icon(
                      Icons.person,
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
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 30,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Date de naissance',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 6),
                ButtonWidget(
                  icon: Icons.calendar_today,
                  text: DateFormat('yMd').format(date).toString(),
                  onClicked: () => pickDate(context),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    child: Text(
                      'Créer Collecteur',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_updateCollecteurKey.currentState!.validate()) {
                        UpdateCollecteur();
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

  void UpdateCollecteur() async {
    //print('widget locationKey: ${widget.collecteurKey}');
    String datedeNaissance = DateFormat('yMd').format(date).toString();
    Map<String, String> newcollecteur = {
      'nomCollecteur': _lastnameCollecteur.text,
      'prenomCollecteur': _firstnameCollecteur.text,
      'datedeNaissance': datedeNaissance,
    };

    _refCollecteur
        .child(widget.collecteurKey)
        .update(newcollecteur)
        .then((value) {
      Navigator.pop(context);
    });
  }
}
