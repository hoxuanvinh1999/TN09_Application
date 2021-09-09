import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/location_page/location_page.dart';

class UpdateLocation extends StatefulWidget {
  String locationKey;

  UpdateLocation({required this.locationKey});

  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  final _updateLocationKey = GlobalKey<FormState>();
  TextEditingController _nameLocationController = TextEditingController();
  TextEditingController _addressLocationController = TextEditingController();
  String newnameLocation = '';
  String newaddressLocation = '';
  String typeSelected = '';

  String oldnameLocation = '';
  String oldaddressLocation = '';

  DatabaseReference _ref =
      FirebaseDatabase.instance.reference().child('Location');

  Widget _buildLocationType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: typeSelected == title
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
          typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Location'),
      ),
      body: Form(
        key: _updateLocationKey,
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameLocationController,
                decoration: InputDecoration(
                  hintText: 'Enter nom de la location',
                  prefixIcon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some information';
                  } else {
                    newnameLocation = value;
                  }
                  print('$newaddressLocation');
                },*/
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _addressLocationController,
                decoration: InputDecoration(
                  hintText: 'Enter address de la location',
                  prefixIcon: Icon(
                    Icons.location_on,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some information';
                  } else {
                    newaddressLocation = value;
                  }
                },*/
              ),
              SizedBox(
                height: 15,
              ),
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
                    'Update Location',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    saveLocation();
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

//Tried to create separate function, but it doesn't work
/*
  getLocationDetail() async {
    print('widget locationKey: ${widget.locationKey}');
    DatabaseReference keyRef = FirebaseDatabase.instance.reference();
    await keyRef
        .child('Location')
        .orderByChild('key')
        .equalTo(widget.locationKey)
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map oldlocation = dataSnapshot.value;
      //oldnameLocation = dataSnapshot.value['nomLocation'];
      //oldaddressLocation = dataSnapshot.value['addressLocation'];
      oldnameLocation = oldlocation['nomLocation'];
      oldaddressLocation = oldlocation['addressLocation'];
    });

    /*String received_key = widget.locationKey;
    Query toGetInformation =
        FirebaseDatabase.instance.reference().child("Location");
    toGetInformation
        .orderByChild("key")
        .equalTo(received_key)
        .once()
        .then((DataSnapshot snapshot) {
      Map<String, dynamic> location = snapshot.value;
      oldnameLocation = location['nomLocation'];
      oldaddressLocation = location['addressLocation'];
      print('key ${location['key']}');
      print('old $oldnameLocation');
    });*/
  }
*/
  void saveLocation() async {
    //getLocationDetail();

    print('widget locationKey: ${widget.locationKey}');
    //print('$_addressLocationController.text');
    //String received_key = widget.locationKey;

    DataSnapshot snapshot = await _ref.child(widget.locationKey).once();
    Map oldlocation = snapshot.value;
    oldnameLocation = oldlocation['nomLocation'];
    oldaddressLocation = oldlocation['addressLocation'];
    print('old $oldnameLocation');

    //didnot work here
    /*
    DatabaseReference keyRef = FirebaseDatabase.instance.reference();
    await keyRef
        .child('Location')
        .orderByChild('key')
        .equalTo(widget.locationKey)
        .once()
        .then((DataSnapshot dataSnapshot) {
      //Map oldlocation = dataSnapshot.value;
      //oldnameLocation = dataSnapshot.value['nomLocation'];
      //oldaddressLocation = dataSnapshot.value['addressLocation'];
      oldnameLocation = dataSnapshot.value['nomLocation'];
      oldaddressLocation = dataSnapshot.value['addressLocation'];
      print(dataSnapshot.value['key']);
    });
    */

    /*String received_key = widget.locationKey;
    Query toGetInformation =
        FirebaseDatabase.instance.reference().child("Location");
    toGetInformation
        .orderByChild("key")
        .equalTo(received_key)
        .once()
        .then((DataSnapshot snapshot) {
      Map<String, dynamic> location = snapshot.value;
      oldnameLocation = location['nomLocation'];
      oldaddressLocation = location['addressLocation'];
      print('key ${location['key']}');
      print('old $oldnameLocation');
    });*/

    newnameLocation = _nameLocationController.text;
    newaddressLocation = _addressLocationController.text;

    print('new $newaddressLocation');

    if (newaddressLocation == oldaddressLocation &&
        newnameLocation == oldnameLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notthing changed')),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LocationPage(),
      ));
    } else {
      Map<String, String> newlocation = {
        'nomLocation': newnameLocation,
        'addressLocation': newaddressLocation,
        'type': typeSelected,
      };

      _ref.child(widget.locationKey).update(newlocation).then((value) {
        Navigator.pop(context);
      });
    }
  }
}
