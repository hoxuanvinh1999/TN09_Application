import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateCle extends StatefulWidget {
  String cleKey;

  UpdateCle({required this.cleKey});

  @override
  _UpdateCleState createState() => _UpdateCleState();
}

class _UpdateCleState extends State<UpdateCle> {
  TextEditingController _nameSite = TextEditingController();
  TextEditingController _numberCle = TextEditingController();
  DatabaseReference _ref = FirebaseDatabase.instance.reference().child('Clé');
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
              controller: _nameSite,
              decoration: InputDecoration(
                hintText: 'Enter Name',
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
              controller: _numberCle,
              decoration: InputDecoration(
                hintText: 'Enter Number',
                prefixIcon: Icon(
                  Icons.phone_iphone,
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
                  _buildCleType('Work'),
                  SizedBox(width: 10),
                  _buildCleType('Family'),
                  SizedBox(width: 10),
                  _buildCleType('Friends'),
                  SizedBox(width: 10),
                  _buildCleType('Others'),
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

  getCleDetail() async {
    DataSnapshot snapshot = await _ref.child(widget.cleKey).once();

    Map cle = snapshot.value;

    _nameSite.text = cle['name'];

    _numberCle.text = cle['number'];

    setState(() {
      _typeSelected = cle['type'];
    });
  }

  void saveCle() {
    getCleDetail();
    String name = _nameSite.text;
    String number = _numberCle.text;

    Map<String, String> cle = {
      'name': name,
      'number': number,
      'type': _typeSelected,
    };

    _ref.child(widget.cleKey).update(cle).then((value) {
      Navigator.pop(context);
    });
  }
}
