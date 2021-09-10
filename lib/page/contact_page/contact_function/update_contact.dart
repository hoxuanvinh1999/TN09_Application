import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../contact_page.dart';

class UpdateContact extends StatefulWidget {
  String contactKey;

  UpdateContact({required this.contactKey});

  @override
  _UpdateContactState createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final _updateContactKey = GlobalKey<FormState>();
  TextEditingController _lastnameContactController = TextEditingController();
  TextEditingController _firstnameContactController = TextEditingController();
  TextEditingController _addressContactController = TextEditingController();
  TextEditingController _telephoneContactController = TextEditingController();
  TextEditingController _mailContactController = TextEditingController();
  TextEditingController _moneyContactController = TextEditingController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _lastnameContactController,
                decoration: InputDecoration(
                  hintText: 'Enter nom du Contact',
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
                controller: _firstnameContactController,
                decoration: InputDecoration(
                  hintText: 'Enter prenom du Contact',
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
                controller: _addressContactController,
                decoration: InputDecoration(
                  hintText: 'Enter address du Contact',
                  prefixIcon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _telephoneContactController,
                decoration: InputDecoration(
                  hintText: 'Enter telephone du Contact',
                  prefixIcon: Icon(
                    Icons.phone,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null ||
                      isNumericUsing_tryParse(value) == false ||
                      value.isEmpty) {
                    return 'Please enter a telephone number';
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _mailContactController,
                decoration: InputDecoration(
                  hintText: 'Enter mail du Contact',
                  prefixIcon: Icon(
                    Icons.contact_mail,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _moneyContactController,
                decoration: InputDecoration(
                  hintText: 'Enter argent du Contact',
                  prefixIcon: Icon(
                    Icons.receipt,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null ||
                      isNumericUsing_tryParse(value) == false ||
                      double.tryParse(value)! < 0 ||
                      value.isEmpty) {
                    return 'Please enter a real number of money';
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
                      SaveContact();
                    }
                  },
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void SaveContact() async {
    print('widget locationKey: ${widget.contactKey}');

    DataSnapshot snapshot = await _refContact.child(widget.contactKey).once();
    Map oldcontact = snapshot.value;
    oldlastnameContact = oldcontact['nomContact'];
    oldfirstnameContact = oldcontact['prenomContact'];
    oldaddressContact = oldcontact['addressContact'];
    oldtelephoneContact = oldcontact['telephoneContact'];
    oldmailContact = oldcontact['mailContact'];
    oldmoneyContact = oldcontact['payerContact'];

    newlastnameContact = _lastnameContactController.text;
    newfirstnameContact = _firstnameContactController.text;
    newaddressContact = _addressContactController.text;
    newtelephoneContact = _telephoneContactController.text;
    newmailContact = _mailContactController.text;
    newmoneyContact = _moneyContactController.text;

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
        'prenomContact': newlastnameContact,
        'addressContact': newaddressContact,
        'telephoneContact': newtelephoneContact,
        'mailContact': newmailContact,
        'payerContact': newmoneyContact,
      };

      _refContact.child(widget.contactKey).update(newcontact).then((value) {
        Navigator.pop(context);
      });
    }
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
