import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/location_page/location_function/choice_address_location.dart';

class CreateLocation extends StatefulWidget {
  String contactKey;

  CreateLocation({required this.contactKey});
  @override
  _CreateLocationState createState() => _CreateLocationState();
}

class _CreateLocationState extends State<CreateLocation> {
  final _LocationKeyForm = GlobalKey<FormState>();
  TextEditingController _nameLocation = TextEditingController();
  TextEditingController _addressLocation = TextEditingController();
  TextEditingController _numberofbac = TextEditingController();
  String _typeSelected = '';

  DatabaseReference referenceContact =
      FirebaseDatabase.instance.reference().child('Contact');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');

  Widget _buildLocationType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _typeSelected == title
              ? Colors.green
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  Future<bool?> dialogDecide(BuildContext context) async {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Cancel Create New Location?'),
              actions: [
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final goback = await dialogDecide(context);
        return goback ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          title: const Text('Créer Location'),
        ),
        body: Container(
            margin: EdgeInsets.all(15),
            child: Form(
                key: _LocationKeyForm,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameLocation,
                        decoration: InputDecoration(
                          hintText: 'Nom de la Location',
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
                      TextFormField(
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
                      SizedBox(height: 15),
                      Container(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildLocationType('Resto'),
                            SizedBox(width: 10),
                            _buildLocationType('Crous'),
                            SizedBox(width: 10),
                            _buildLocationType('Cantine'),
                            SizedBox(width: 10),
                            _buildLocationType('Autre'),
                          ],
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
                            'Choice Address',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            if (_LocationKeyForm.currentState!.validate()) {
                              SaveLocation();
                            }
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  void SaveLocation() async {
    String nomLocation = _nameLocation.text;
    String nombredebac = _numberofbac.text;
    Map<String, String> location = {
      'nombredebac': nombredebac,
      'contact_key': widget.contactKey,
      'nomLocation': nomLocation,
      'type': _typeSelected,
      'nombredecle': '0',
      'showed': 'false',
      'checked': 'creating',
    };
    referenceLocation.push().set(location).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChoideAddressLocation(
                    contactKey: widget.contactKey,
                    reason: 'finishLocation',
                  )));
    });
  }
}
