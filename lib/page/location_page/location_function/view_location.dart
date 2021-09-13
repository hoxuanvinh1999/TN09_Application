import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/delete_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/view_information_cle.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/update_contact.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_list_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/create_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/update_location.dart';
import 'package:tn09_app_demo/page/location_page/location_page.dart';

class ViewLocation extends StatefulWidget {
  String locationKey;
  ViewLocation({required this.locationKey});

  @override
  _ViewLocationState createState() => _ViewLocationState();
}

class _ViewLocationState extends State<ViewLocation> {
  Query _referenceCle = FirebaseDatabase.instance
      .reference()
      .child('Cle')
      .orderByChild('noteCle');
  Query _referenceLocation = FirebaseDatabase.instance
      .reference()
      .child('Location')
      .orderByChild('nomLocation');
  DatabaseReference _refCle =
      FirebaseDatabase.instance.reference().child('Cle');
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');

  Widget _buildLocationItem({required Map location}) {
    Color typeColor = getTypeColor(location['type']);
    if (location['key'] == widget.locationKey) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        height: 180,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.home,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  location['nomLocation'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  location['addressLocation'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 15),
                Icon(
                  Icons.vpn_key,
                  color: typeColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  location['nombredecle'],
                  style: TextStyle(
                      fontSize: 16,
                      color: typeColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.category,
                  color: typeColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  location['type'],
                  style: TextStyle(
                      fontSize: 16,
                      color: typeColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    print('key before send ${location['contact_key']}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewContact(
                                contactKey: location['contact_key'])));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.checklist_rtl,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('View Contact',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
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
                            builder: (_) =>
                                UpdateLocation(locationKey: location['key'])));
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
                      Text('Edit',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _showDeleteDialog(location: location);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red[700],
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
            ),
            SizedBox(
              height: 8,
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
                            builder: (_) =>
                                CreateCle(locationKey: location['key'])));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Add Key',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewInformationCle(
                                locationKey: location['key'])));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.view_list,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('View Key',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
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
    } else {
      //need to fine other way
      return SizedBox.shrink();
    }
  }

  _showDeleteDialog({required Map location}) {
    print('Indo delete function');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${location['nomcontact']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    String location_key = location['key'];
                    //print('location key to delete: $text');
                    deleteCle(location_key: location_key);
                    _refLocation
                        .child(location['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Information'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _referenceLocation,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            //print('inside ${widget.locationKey}');
            Map location = snapshot.value;
            location['key'] = snapshot.key;
            return _buildLocationItem(location: location);
          },
        ),
      ),
    );
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;
    switch (type) {
      case 'Resto':
        color = Colors.brown;
        break;
      case 'Crous':
        color = Colors.green;
        break;
      case 'Cantine':
        color = Colors.teal;
        break;
      case 'Autre':
        color = Colors.black;
        break;
      default:
        color = Colors.red;
        break;
    }
    return color;
  }
}
