import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_etape_item_planning.dart';

class buildEtapePlanning extends StatefulWidget {
  String etape_key;
  BuildContext context;
  buildEtapePlanning({required this.context, required this.etape_key});
  @override
  _buildEtapePlanningState createState() => _buildEtapePlanningState();
}

class _buildEtapePlanningState extends State<buildEtapePlanning> {
  String nomLocationEtape = '';
  String addressLocationEtape = '';
  String materialEtape = '';
  String nombredebac = '';
  String thisEtape_key = '';
  String afterEtape_key = '';
  Map nextetap = {};
  @override
  Widget build(BuildContext context) =>
      buildInformation(context: widget.context, etape_key: widget.etape_key);

  Widget buildInformation(
      {required BuildContext context, required String etape_key}) {
    getInformation(etapeKey: widget.etape_key);
    if (afterEtape_key != 'null') {
      buildEtapePlanning(
        context: context,
        etape_key: afterEtape_key,
      );
    }
    return Container(
      height: 150,
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
                nomLocationEtape,
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
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                addressLocationEtape,
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
                Icons.restore_from_trash,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                materialEtape,
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
                Icons.restore_from_trash,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                nombredebac,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getInformation({required String etapeKey}) async {
    DatabaseReference _refEtape =
        FirebaseDatabase.instance.reference().child('Etape');
    await _refEtape.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> planning = snapshot.value;
      planning.forEach((key, values) {
        if (key == etapeKey) {
          nomLocationEtape = values['nomLocationEtape'];
          addressLocationEtape = values['addressLocationEtape'];
          materialEtape = values['materialEtape'];
          nombredebac = values['nombredebac'];
          afterEtape_key = values['afterEtape_key'];
        }
      });
    });
  }
}
