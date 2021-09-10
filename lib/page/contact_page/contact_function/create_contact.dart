import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class CreateContact extends StatefulWidget {
  @override
  _CreateContactState createState() => _CreateContactState();
}

class _CreateContactState extends State<CreateContact> {
  final _contactKeyForm = GlobalKey<FormState>();
  TextEditingController _lastnameContact = TextEditingController();
  TextEditingController _firstnameContact = TextEditingController();
  TextEditingController _addressContact = TextEditingController();
  TextEditingController _telephoneContact = TextEditingController();
  TextEditingController _mailContact = TextEditingController();

  DatabaseReference _refContact =
      FirebaseDatabase.instance.reference().child('Contact');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer Contact'),
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          height: double.infinity,
          child: Form(
            key: _contactKeyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _lastnameContact,
                  decoration: InputDecoration(
                    hintText: 'Nom du Contact',
                    prefixIcon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _firstnameContact,
                  decoration: InputDecoration(
                    hintText: 'Prenom du Contact',
                    prefixIcon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                TextFormField(
                  controller: _addressContact,
                  decoration: InputDecoration(
                    hintText: 'Address du Contact',
                    prefixIcon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
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
                TextFormField(
                  controller: _mailContact,
                  decoration: InputDecoration(
                    hintText: 'Mail du Contact',
                    prefixIcon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    child: Text(
                      'Créer Contact',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_contactKeyForm.currentState!.validate()) {
                        SaveContact();
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

  void SaveContact() {
    String nomContact = _lastnameContact.text;
    String prenomContact = _firstnameContact.text;
    String datecreeContact = DateFormat('yMd').format(DateTime.now());
    String addressContact = _addressContact.text;
    String telephoneContact = _telephoneContact.text;
    String mailContact = _mailContact.text;

    Map<String, String> contact = {
      'nomContact': nomContact,
      'prenomContact': prenomContact,
      'datecreeContact': datecreeContact,
      'addressContact': addressContact,
      'telephoneContact': telephoneContact,
      'mailContact': mailContact,
      'payerContact': '0',
      'nombredelocation': '0',
    };

    _refContact.push().set(contact).then((value) {
      Navigator.pop(context);
    });
  }

  bool isNumericUsing_tryParse(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }
    final number = num.tryParse(string);
    if (number == null) {
      return false;
    }
    return true;
  }
}
