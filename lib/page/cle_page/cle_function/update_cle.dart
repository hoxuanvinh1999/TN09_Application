import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../cle_page.dart';

class UpdateCle extends StatefulWidget {
  String cleKey;

  UpdateCle({required this.cleKey});

  @override
  _UpdateCleState createState() => _UpdateCleState();
}

class _UpdateCleState extends State<UpdateCle> {
  TextEditingController _noteKey = TextEditingController();
  DatabaseReference _refCle =
      FirebaseDatabase.instance.reference().child('Cle');
  String _typeSelected = '';

  Widget _buildCleType(String title) {
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
        title: Text('Update Cle'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _noteKey,
              decoration: InputDecoration(
                hintText: 'Enter New Note',
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
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCleType('Cle'),
                  SizedBox(width: 10),
                  _buildCleType('Badge'),
                  SizedBox(width: 10),
                  _buildCleType('Carte'),
                  SizedBox(width: 10),
                  _buildCleType('Autre'),
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
                  'Update Cle',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  saveCle();
                },
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveCle() async {
    print('widget locationKey: ${widget.cleKey}');

    DataSnapshot snapshot = await _refCle.child(widget.cleKey).once();
    Map oldkey = snapshot.value;

    String newnotekey = _noteKey.text;

    if (newnotekey == oldkey['noteCle']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notthing changed')),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ClePage(),
      ));
    } else {
      Map<String, String> newCle = {
        'noteCle': newnotekey,
      };

      _refCle.child(widget.cleKey).update(newCle).then((value) {
        Navigator.pop(context);
      });
    }
  }
}
