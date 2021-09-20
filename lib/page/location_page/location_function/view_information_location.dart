import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/delete_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/view_information_cle.dart';
import 'package:tn09_app_demo/page/location_page/location_function/build_item_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/create_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/create_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/get_type_color_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/update_location.dart';
import 'package:tn09_app_demo/widget/border_decoration.dart';

class ViewInformationLocation extends StatefulWidget {
  String contactKey;

  ViewInformationLocation({required this.contactKey});

  @override
  _ViewInformationLocationState createState() =>
      _ViewInformationLocationState();
}

class _ViewInformationLocationState extends State<ViewInformationLocation> {
  String nameLocation = '';
  String addressLocation = '';
  String numberofKey = '';
  String typeLocation = '';
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference _refContact =
      FirebaseDatabase.instance.reference().child('Contact');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Location and Information'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _refLocation.orderByChild('contact_key'),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map location = snapshot.value;
            location['key'] = snapshot.key;
            print('location key ${location['contact_key']}');
            print('widget contactkey ${widget.contactKey} ');
            if (location['contact_key'] == widget.contactKey) {
              return buildItemLocation(context: context, location: location);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return CreateLocation(contactKey: widget.contactKey);
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
