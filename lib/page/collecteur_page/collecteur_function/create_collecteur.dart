import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class CreateCollecteur extends StatefulWidget {
  @override
  _CreateCollecteurState createState() => _CreateCollecteurState();
}

class _CreateCollecteurState extends State<CreateCollecteur> {
  final _collecteurKeyForm = GlobalKey<FormState>();
  TextEditingController _lastnameCollecteur = TextEditingController();
  TextEditingController _firstnameCollecteur = TextEditingController();

  DatabaseReference _refCollecteur =
      FirebaseDatabase.instance.reference().child('Collecteur');
  DateTime date = DateTime.now();

  String getText() {
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
        title: const Text('Créer Collecteur'),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          height: double.infinity,
          child: Form(
            key: _collecteurKeyForm,
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
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 30,
                    ),
                    hintText: 'Telephone',
                  ),
                  validator: (value) {
                    if (value == null ||
                        isNumericUsing_tryParse(value) == false ||
                        value.isEmpty) {
                      return 'Please enter a telephone number';
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
                      if (_collecteurKeyForm.currentState!.validate()) {
                        SaveCollecteur();
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

  void SaveCollecteur() {
    String nomCollecteur = _lastnameCollecteur.text;
    String prenomCollecteur = _firstnameCollecteur.text;
    String datedeNaissance = DateFormat('yMd').format(date).toString();

    Map<String, String> collecteur = {
      'nomCollecteur': nomCollecteur,
      'prenomCollecteur': prenomCollecteur,
      'datedeNaissance': datedeNaissance,
    };

    _refCollecteur.push().set(collecteur).then((value) {
      Navigator.pop(context);
    });
  }
}
