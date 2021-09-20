import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/build_item_contact.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_item_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';

class ShowEtape extends StatefulWidget {
  @override
  _ShowEtapeState createState() => _ShowEtapeState();
}

class _ShowEtapeState extends State<ShowEtape> {
  Query _refEtape =
      FirebaseDatabase.instance.reference().child('Etape').orderByChild('key');
  DatabaseReference referenceEptae =
      FirebaseDatabase.instance.reference().child('Contact');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('List Etape'),
            /*
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),*/
          ),
          body: Container(
            height: double.infinity,
            child: FirebaseAnimatedList(
              query: _refEtape,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map etape = snapshot.value;
                etape['key'] = snapshot.key;
                return buildItemEtape(context: context, etape: etape);
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return CreateEtape(
                    reason: 'createEtape',
                    numberofEtape: 'null',
                  );
                }),
              );
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
        ));
  }
}
