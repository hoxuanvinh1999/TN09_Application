import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/widget/build_decoration.dart';

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _lastnameContact,
                    decoration: buildInputDecoration(
                        'Nom du Contact', '', Icon(Icons.person, size: 30)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This can not be null';
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _firstnameContact,
                    decoration: buildInputDecoration(
                        'Prenom du Contact',
                        '',
                        Icon(
                          null,
                          size: 30,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This can not be null';
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _addressContact,
                    decoration: buildInputDecoration(
                        'Address du Contact',
                        '',
                        Icon(
                          Icons.home,
                          size: 30,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This can not be null';
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _telephoneContact,
                    decoration: buildInputDecoration(
                        'Phone du Contact',
                        '',
                        Icon(
                          Icons.phone,
                          size: 30,
                        )),
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
                    decoration: buildInputDecoration(
                        'Enter mail du Contact',
                        '',
                        Icon(
                          Icons.contact_mail,
                          size: 30,
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This can not be null';
                        /* } else if (!isEmail(value)) {
                      return 'please enter a mail';*/
                      }
                    },
                  ),
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
}
