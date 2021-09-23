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
import 'package:tn09_app_demo/page/etape_page/etape_function/confirm_etape.dart';

class LocationSearch extends SearchDelegate<String> {
  String reason;
  String numberofEtape;
  List<String> listNomLocation;
  LocationSearch({
    required this.reason,
    required this.numberofEtape,
    required this.listNomLocation,
  });
  int position = 0;
  List<Map<String, String>> listLocation = [];
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? listNomLocation
        : listNomLocation.where((choice) {
            final choiceLower = choice.toLowerCase();
            final queryLower = query.toLowerCase();

            return choice.startsWith(queryLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () async {
              query = suggestion;
              print('$query');
              position = listNomLocation.indexOf(query);
              //print(' position: $position');
              //print('$listLocation');
              DatabaseReference referenceLocation =
                  FirebaseDatabase.instance.reference().child('Location');
              for (int i = 0; i < listNomLocation.length; i++) {
                await referenceLocation.once().then((DataSnapshot snapshot) {
                  Map<dynamic, dynamic> location = snapshot.value;
                  location.forEach((key, values) {
                    if (values['showed'] == 'false') {
                      //print('ListNomLocation: $listNomLocation');
                      //print('listLocation lenght : ${listLocation.length}');
                      //print('numberofLocation $numberofLocation');
                      Map<String, String> itemLocation = {
                        'key': key,
                        'nombredebac': values['nombredebac'],
                        'contact_key': values['contact_key'],
                        'nomLocation': values['nomLocation'],
                        'addressLocation': values['addressLocation'],
                        'type': values['type'],
                        'nombredecle': values['nombredecle'],
                        'showed': values['showed'],
                      };
                      if (!listLocation.contains(itemLocation)) {
                        listLocation.add(itemLocation);
                      }
                    }
                  });
                });
              }
              //print('$listLocation');
              //print('$listNomLocation');
              // 1. Show Results
              //showResults(context);

              // 2. Close Search & Return Result
              // close(context, suggestion);

              //3. Navigate to Result Page
              if (reason == 'createEtape') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ConfirmEtape(
                      location: listLocation[position],
                      reason: 'confirmEtape',
                      numberofEtape: 'null',
                    );
                  }),
                );
              } else if (reason == 'createPlanning') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ConfirmEtape(
                      location: listLocation[position],
                      reason: 'createPlanning',
                      numberofEtape: numberofEtape,
                    );
                  }),
                );
              } else if (reason == 'continuePlanning') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ConfirmEtape(
                      location: listLocation[position],
                      reason: 'continuePlanning',
                      numberofEtape: numberofEtape,
                    );
                  }),
                );
              } else {
                updateLocationEtape(
                    location: listLocation[position], etapeKey: reason);
                Navigator.pop(context);
              }
            },
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
