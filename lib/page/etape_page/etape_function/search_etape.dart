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
import 'package:tn09_app_demo/page/planning_page/planning_function/next_step_create_planning.dart';

class EtapeSearch extends SearchDelegate<String> {
  BuildContext context;
  String reason;
  String numberofEtape;
  List<String> listNomEtape;
  EtapeSearch({
    required this.context,
    required this.reason,
    required this.numberofEtape,
    required this.listNomEtape,
  });
  int position = 0;
  List<Map<String, String>> listEtape = [];
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
        ? listNomEtape
        : listNomEtape.where((choice) {
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
              position = listNomEtape.indexOf(query);
              //print(' position: $position');
              //print('$listNomEtape');
              DatabaseReference referenceEtape =
                  FirebaseDatabase.instance.reference().child('Etape');
              for (int i = 0; i < listNomEtape.length; i++) {
                await referenceEtape.once().then((DataSnapshot snapshot) {
                  Map<dynamic, dynamic> etape = snapshot.value;
                  etape.forEach((key, values) {
                    if (values['showed'] == 'false') {
                      Map<String, String> itemEtape = {
                        'key': key,
                        'addressLocationEtape': values['addressLocationEtape'],
                        'beforeEtape_key': values['beforeEtape_key'],
                        'checked': values['checked'],
                        'contact_key': values['contact_key'],
                        'dateEtape': values['dateEtape'],
                        'location_key': values['location_key'],
                        'materialEtape': values['materialEtape'],
                        'nomLocationEtape': values['nomLocationEtape'],
                        'nombredebac': values['nombredebac'],
                        'planning_key': values['planning_key'],
                        'reason_not_checked': values['reason_not_checked'],
                        'noteEtape': values['noteEtape'],
                        'showed': values['showed'],
                      };
                      if (!listEtape.contains(itemEtape)) {
                        listEtape.add(itemEtape);
                      }
                    }
                  });
                });
              }
              //print('ListEtape qqqqqqqqqqqqqqqqqqqqqqqqq $listEtape');
              //print('$listNomLocation');
              // 1. Show Results
              //showResults(context);

              // 2. Close Search & Return Result
              // close(context, suggestion);

              //3. Navigate to Result Page
              //print('Element ppppppppppppppppppp ${listEtape[position]}');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return NextStepCreatePlanning(
                    etape: listEtape[position],
                    reason: reason,
                    numberofEtape: numberofEtape,
                    context: context,
                  );
                }),
              );
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
