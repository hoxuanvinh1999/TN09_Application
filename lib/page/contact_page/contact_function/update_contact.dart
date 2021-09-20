import 'dart:async';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/math_function/is_mail.dart';
import 'package:tn09_app_demo/page/contact_page/contact_page.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/widget/build_decoration.dart';

class UpdateContact extends StatefulWidget {
  Map contact;

  UpdateContact({required this.contact});

  @override
  _UpdateContactState createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final _updateContactKey = GlobalKey<FormState>();

  String newlastnameContact = '';
  String newfirstnameContact = '';
  String newaddressContact = '';
  String newtelephoneContact = '';
  String newmailContact = '';
  String newmoneyContact = '';

  String oldlastnameContact = '';
  String oldfirstnameContact = '';
  String oldaddressContact = '';
  String oldtelephoneContact = '';
  String oldmailContact = '';
  String oldmoneyContact = '';

  DatabaseReference _refContact =
      FirebaseDatabase.instance.reference().child('Contact');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contact'),
      ),
      body: Form(
        key: _updateContactKey,
        child: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.contact['nomContact'],
                  decoration: buildInputDecoration(
                      'Nom du Contact', '', Icon(Icons.person, size: 30)),
                  /*
                decoration: InputDecoration(
                  hintText: 'Enter nom du Contact',
                  prefixIcon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),*/
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This can not be null';
                    } else {
                      setState(() {
                        newlastnameContact = value;
                        print('$newlastnameContact');
                      });
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  initialValue: widget.contact['prenomContact'],
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
                    } else {
                      setState(() {
                        newfirstnameContact = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  initialValue: widget.contact['addressContact'],
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
                    } else {
                      setState(() {
                        newaddressContact = value;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                    initialValue: widget.contact['telephoneContact'],
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
                      } else {
                        setState(() {
                          newtelephoneContact = value;
                        });
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: widget.contact['mailContact'],
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
                    } else {
                      setState(() {
                        newmailContact = value;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: widget.contact['payerContact'],
                  decoration: buildInputDecoration(
                      'Enter argent du Contact',
                      '',
                      Icon(
                        Icons.receipt,
                        size: 30,
                      )),
                  validator: (value) {
                    if (value == null ||
                        isNumericUsing_tryParse(value) == false ||
                        double.tryParse(value)! < 0 ||
                        value.isEmpty) {
                      return 'Please enter a real number of money';
                    } else {
                      setState(() {
                        newmoneyContact = value;
                      });
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
                      'Update Contact',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_updateContactKey.currentState!.validate()) {
                        UpdateContact();
                      }
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void UpdateContact() async {
    //print('widget locationKey: ${widget.contact['key']}');

    DataSnapshot snapshot =
        await _refContact.child(widget.contact['key']).once();
    Map oldcontact = snapshot.value;
    oldlastnameContact = oldcontact['nomContact'];
    oldfirstnameContact = oldcontact['prenomContact'];
    oldaddressContact = oldcontact['addressContact'];
    oldtelephoneContact = oldcontact['telephoneContact'];
    oldmailContact = oldcontact['mailContact'];
    oldmoneyContact = oldcontact['payerContact'];
    if (oldlastnameContact == newlastnameContact &&
        oldfirstnameContact == newfirstnameContact &&
        oldaddressContact == newaddressContact &&
        oldtelephoneContact == newtelephoneContact &&
        oldmailContact == newmailContact &&
        oldmoneyContact == newmoneyContact) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notthing changed')),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContactPage(),
      ));
    } else {
      Map<String, String> newcontact = {
        'nomContact': newlastnameContact,
        'prenomContact': newfirstnameContact,
        'addressContact': newaddressContact,
        'telephoneContact': newtelephoneContact,
        'mailContact': newmailContact,
        'payerContact': newmoneyContact,
      };

      _refContact.child(widget.contact['key']).update(newcontact).then((value) {
        Navigator.pop(context);
      });
    }
  }
}
