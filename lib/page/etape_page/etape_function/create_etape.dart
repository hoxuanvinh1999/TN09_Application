import 'package:flutter/material.dart';
import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_choice_location_etape.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class CreateEtape extends StatefulWidget {
  String reason;
  String numberofEtape;
  CreateEtape({required this.reason, required this.numberofEtape});
  @override
  _CreateEtapeState createState() => _CreateEtapeState();
}

class _CreateEtapeState extends State<CreateEtape> {
  Query _refLocation = FirebaseDatabase.instance
      .reference()
      .child('Location')
      .orderByChild('nomeLocation');

  /*
  String? value;
  Query _refLocation = FirebaseDatabase.instance
      .reference()
      .child('Location')
      .orderByChild('nomLocation');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');
    createList() async {
    List<String> result = [];
    await FirebaseDatabase.instance
        .reference()
        .child('Location')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> location = snapshot.value;
      for (dynamic values in location.values) {
        String trans = values['nomLocation'].toString();
        result.add(trans);
        print('$result');
      }
      /*
        location.forEach((key, values) {
        print('Into ForEach');
        print('${values['nomLocation']}');
        String trans = values['nomLocation'].toString();
        result.add(trans);
        print('result: $result');
      });*/
    });
    print('result: $result');

    return result;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 16),
        ),
      );
      */
  Widget setTitle() {
    if (widget.reason == 'createEtape') {
      return Text('Creér Etape');
    } else {
      return Text('Creating Planning...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: setTitle(),
      ),
      /*body: Center(
        child: DropdownButton<String>(
          items: createList().map(buildMenuItem).toList(),
          onChanged: (value) => setState(() => this.value = value),
        ),
      ),*/
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _refLocation,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map location = snapshot.value;
            location['key'] = snapshot.key;
            return buildChoiceLocation(
                context: context,
                location: location,
                reason: widget.reason,
                numberofEtape: widget.numberofEtape);
          },
        ),
      ),
    );
  }
}
