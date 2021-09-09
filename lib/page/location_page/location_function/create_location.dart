import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class CreateLocation extends StatefulWidget {
  @override
  _CreateLocationState createState() => _CreateLocationState();
}

class _CreateLocationState extends State<CreateLocation> {
  TextEditingController _nameLocation = TextEditingController();
  TextEditingController _addressLocation = TextEditingController();
  String _typeSelected = '';

  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');

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
        title: const Text('Créer Location'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameLocation,
              decoration: InputDecoration(
                hintText: 'Nom de la Location',
                prefixIcon: Icon(
                  Icons.account_circle,
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
                hintText: 'Address de la Location',
                prefixIcon: Icon(
                  Icons.add,
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
                  'Créer Location',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  SaveLocation();
                },
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  void SaveLocation() {
    String nameSite = _nameLocation.text;
    String numberSite = _addressLocation.text;

    Map<String, String> location = {
      'nomLocation': nameSite,
      'addressLocation': numberSite,
      'type': _typeSelected,
      'nombredecle': '0',
    };

    _refLocation.push().set(location).then((value) {
      Navigator.pop(context);
    });
  }
}
