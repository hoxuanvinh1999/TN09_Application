import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/location_page/location_page.dart';

class UpdateLocation extends StatefulWidget {
  Map location;

  UpdateLocation({required this.location});

  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  final _updateLocationKey = GlobalKey<FormState>();
  String newnameLocation = '';
  String typeSelected = '';

  String oldnameLocation = '';

  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference _refEtape =
      FirebaseDatabase.instance.reference().child('Etape');

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
                initialValue: widget.location['nomLocation'],
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This can not be null';
                  } else {
                    setState(() {
                      print('value $value');
                      newnameLocation = value;
                      print('newnameLocation $newnameLocation');
                    });
                  }
                },
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
                    if (_updateLocationKey.currentState!.validate() &&
                        typeSelected != '') {
                      updateLocation();
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
  void updateLocation() async {
    //getLocationDetail();

    // print('widget locationKey: ${widget.location['key']}');
    //print('$_addressLocationController.text');
    //String received_key = widget.locationKey;

    // int nombreofcle = int.parse(numberofcle);

    //print('old $oldnameLocation');

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
    oldnameLocation = widget.location['nomLocation'];
    Map<String, String> newlocation = {
      'nomLocation': newnameLocation,
      'type': typeSelected,
    };
    print('newnameLocation $newnameLocation');
    print('typeSelected /// $typeSelected');
    //print('new $newaddressLocation');

    if (newnameLocation == oldnameLocation &&
        widget.location['type'] == typeSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notthing changed')),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LocationPage(),
      ));
    } else {
      await _refEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['location_key'] == widget.location['key']) {
            print('Into If right');
            Map<String, String> etape = {
              'nomLocationEtape': newnameLocation,
            };
            _refEtape.child(key).update(etape);
          }
        });
      });
      _refLocation
          .child(widget.location['key'])
          .update(newlocation)
          .then((value) {
        Navigator.pop(context);
      });
    }
  }
}
