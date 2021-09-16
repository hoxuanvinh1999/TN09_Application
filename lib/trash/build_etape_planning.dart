import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/build_etape_item_planning.dart';

class buildEtapePlanning extends StatefulWidget {
  String etape_key;
  BuildContext context;
  String numberofEtape;
  buildEtapePlanning(
      {required this.context,
      required this.etape_key,
      required this.numberofEtape});
  @override
  _buildEtapePlanningState createState() => _buildEtapePlanningState();
}

class _buildEtapePlanningState extends State<buildEtapePlanning> {
  List<String> listNomLocationEtape = [];
  List<String> listAddressLocationEtape = [];
  List<String> listMaterialEtape = [];
  List<String> listNombredebacEtape = [];
  List<Widget> listWidget = [];
  getInformation({required String etapeKey}) async {
    DatabaseReference _refEtape =
        FirebaseDatabase.instance.reference().child('Etape');

    @override
    String etape_key = widget.etape_key;
    int numberofEtape = int.parse(widget.numberofEtape);
    for (int i = 0; i < numberofEtape; i++) {
      await _refEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> planning = snapshot.value;
        planning.forEach((key, values) {
          if (key == etapeKey) {
            listNomLocationEtape.add(values['nomLocationEtape']);
            listAddressLocationEtape.add(values['addressLocationEtape']);
            listMaterialEtape.add(values['materialEtape']);
            listNombredebacEtape.add(values['nombredebac']);
            etape_key = values['afterEtape_key'];
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150 * double.parse(widget.numberofEtape),
        child: ListView(children: buildInformation()));
  }

  List<Widget> buildInformation() {
    getInformation(etapeKey: widget.etape_key);
    print('$listNomLocationEtape');
    int numberofEtape = int.parse(widget.numberofEtape);
    print('$numberofEtape');
    for (int i = 0; i < listNomLocationEtape.length; i++) {
      listWidget.add(new Container(
        color: Colors.white,
        child: Column(
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
                  listNomLocationEtape[i],
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
                  listAddressLocationEtape[i],
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
                  listMaterialEtape[i],
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
                  listNombredebacEtape[i],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ));
    }
    return listWidget;
  }
}
