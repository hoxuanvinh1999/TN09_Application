import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/build_item_contact.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/update_contact.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_information_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/create_location.dart';
import 'package:tn09_app_demo/page/location_page/location_page.dart';

class ViewContact extends StatefulWidget {
  String contactKey;
  ViewContact({required this.contactKey});

  @override
  _ViewContactState createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  Query _referenceContact = FirebaseDatabase.instance
      .reference()
      .child('Contact')
      .orderByChild('nomContact');
  DatabaseReference _refContact =
      FirebaseDatabase.instance.reference().child('Contact');
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Contact');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Information'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _referenceContact,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            print('inside ${widget.contactKey}');
            Map contact = snapshot.value;
            contact['key'] = snapshot.key;
            if (contact['key'] == widget.contactKey) {
              return buildItemContact(context: context, contact: contact);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
