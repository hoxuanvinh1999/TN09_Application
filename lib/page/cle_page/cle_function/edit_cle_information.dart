import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';

import 'update_cle.dart';
import 'create_cle.dart';

class EditCleInformation extends StatefulWidget {
  String locationKey;

  EditCleInformation({required this.locationKey});

  @override
  _EditCleInformationState createState() => _EditCleInformationState();
}

class _EditCleInformationState extends State<EditCleInformation> {
  String nameLocation = '';
  String addressLocation = '';
  String numberofKey = '';
  String typeLocation = '';
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference _refCle =
      FirebaseDatabase.instance.reference().child('Cle');

  Widget _buildCleItem({required Map cle}) {
    Color typeColor = getTypeColor(cle['type']);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      height: 130,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                cle['noteCle'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                Icons.group_work,
                color: typeColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                cle['type'],
                style: TextStyle(
                    fontSize: 16,
                    color: typeColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  //print('key before send ${location['key']}');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UpdateCle(cleKey: cle['key'])));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Edit Cle',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(cle: cle);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Delete',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Cle Information'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query:
              _refCle.orderByChild('location_key').equalTo(widget.locationKey),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map cle = snapshot.value;
            cle['key'] = snapshot.key;
            return _buildCleItem(cle: cle);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return CreateCle(locationKey: widget.locationKey);
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  _showDeleteDialog({required Map cle}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Cle'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    reduceNumberofKey();
                    _refCle
                        .child(cle['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  void reduceNumberofKey() async {
    String cleTableSecurityPass = 'check';
    DataSnapshot snapshotlocation =
        await _refLocation.child(widget.locationKey).once();
    Map location = snapshotlocation.value;
    String nombreofCle = location['nombredecle'];
    nombreofCle = (int.parse(nombreofCle) - 1).toString();
    Map<String, String> updatelocation = {
      'nombredecle': nombreofCle,
    };
    _refLocation.child(widget.locationKey).update(updatelocation);
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;
    switch (type) {
      case 'Cle':
        color = Colors.brown;
        break;
      case 'Badge':
        color = Colors.green;
        break;
      case 'Carte':
        color = Colors.teal;
        break;
      case 'Autre':
        color = Colors.grey;
        break;
      default:
        color = Colors.red;
        break;
    }
    return color;
  }
}
