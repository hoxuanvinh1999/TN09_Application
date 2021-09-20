import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_page.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';

class UpdateContact extends StatefulWidget {
  Map contact;

  UpdateContact({required this.contact});

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
  /*
  void initState() {
    super.initState();
    _firstnameContactController.text = widget.contact['prenomContact'];
    _lastnameContactController.text = widget.contact['nomContact'];
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                //controller: _lastnameContactController,
                initialValue: widget.contact['nomContact'],
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
                validator: (value) {
                  if (value != null) {
                    setState(() {
                      newlastnameContact = value;
                      print('$newlastnameContact');
                    });
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                //controller: _firstnameContactController,
                initialValue: widget.contact['prenomContact'],
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
                validator: (value) {
                  if (value != null) {
                    setState(() {
                      newfirstnameContact = value;
                    });
                  }
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                //controller: _addressContactController,
                initialValue: widget.contact['addressContact'],
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
                validator: (value) {
                  if (value != null) {
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
                  //controller: _telephoneContactController,
                  initialValue: widget.contact['telephoneContact'],
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
                //controller: _mailContactController,
                initialValue: widget.contact['mailContact'],
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
                validator: (value) {
                  if (value != null) {
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
                //controller: _moneyContactController,
                initialValue: widget.contact['payerContact'],
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
    );
  }

  void UpdateContact() async {
    print('into Update Contact');
    print('widget locationKey: ${widget.contact['key']}');

    DataSnapshot snapshot =
        await _refContact.child(widget.contact['key']).once();
    Map oldcontact = snapshot.value;
    oldlastnameContact = oldcontact['nomContact'];
    oldfirstnameContact = oldcontact['prenomContact'];
    oldaddressContact = oldcontact['addressContact'];
    oldtelephoneContact = oldcontact['telephoneContact'];
    oldmailContact = oldcontact['mailContact'];
    oldmoneyContact = oldcontact['payerContact'];
    /*
    newlastnameContact = _lastnameContactController.text;
    newfirstnameContact = _firstnameContactController.text;
    newaddressContact = _addressContactController.text;
    newtelephoneContact = _telephoneContactController.text;
    newmailContact = _mailContactController.text;
    newmoneyContact = _moneyContactController.text;
    */
    print('$newlastnameContact');
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

      _refContact.child(widget.contact['key']).update(newcontact).then((value) {
        Navigator.pop(context);
      });
    }
  }
}
