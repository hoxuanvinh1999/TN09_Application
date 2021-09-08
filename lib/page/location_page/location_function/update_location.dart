import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateLocation extends StatefulWidget {
  String locationKey;

  UpdateLocation({required this.locationKey});

  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  TextEditingController _nameLocation = TextEditingController();
  TextEditingController _addressLocation = TextEditingController();
  String _typeSelected = '';

  DatabaseReference _ref =
      FirebaseDatabase.instance.reference().child('location');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Location'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Text(
                  'Get Information de la Location',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  getLocationDetail();
                },
                color: Theme.of(context).primaryColor,
              ),
            ),
            TextFormField(
              controller: _nameLocation,
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
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _addressLocation,
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
    );
  }

  getLocationDetail() async {
    DataSnapshot snapshot = await _ref.child(widget.locationKey).once();

    Map location = snapshot.value;

    _nameLocation.text = location['nomLocation'];

    print('Delete ${location['nomLocation']}');
    print('$_addressLocation');

    _addressLocation.text = location['addressLocation'];

    print('Delete ${location['address']}');
    print('$_addressLocation');

    setState(() {
      _typeSelected = location['type'];
      print('${location['type']}');
      print('$_typeSelected');
    });
  }

  void saveLocation() {
    String nameLocation = _nameLocation.text;
    String addressLocation = _addressLocation.text;

    Map<String, String> newlocation = {
      'nomLocation': nameLocation,
      'addressLocation': addressLocation,
      'type': _typeSelected,
    };

    _ref.child(widget.locationKey).update(newlocation).then((value) {
      Navigator.pop(context);
    });
  }
}
