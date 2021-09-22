import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/change_location_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/show_delete_dialog_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/update_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/view_planning_etape.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_information_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_location.dart';
import 'package:tn09_app_demo/widget/border_decoration.dart';

Widget buildItemEtape({required BuildContext context, required Map etape}) {
  return Container(
    decoration: buildBorderDecoration(),
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    padding: EdgeInsets.all(10),
    height: 300,
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
              'Nom de la Location: ' + etape['nomLocationEtape'],
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 15,
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
              'Address de la Location:  ' + etape['addressLocationEtape'],
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Icon(
              Icons.restore_from_trash,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Material: ' + etape['materialEtape'],
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Icon(
              Icons.restore_from_trash,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Nombre de bac ' + etape['nombredebac'],
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Icon(
              Icons.sticky_note_2,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Note ' + etape['noteEtape'],
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ChangeLocationEtape(etapeKey: etape['key'])));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text('Change Location',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(
              width: 6,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateEtape(etapeKey: etape['key'])));
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
                showDeleteDialogEtape(context: context, etape: etape);
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
                            ViewContact(contactKey: etape['contact_key'])));
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
                  Text('View Contact',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () {
                //print('key before send ${location['key']}');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ViewLocation(locationKey: etape['location_key'])));
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
                  Text('View Location',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewPlanningEtape(
                            planning_key: etape['planning_key'])));
              },
              child: Row(
                children: [
                  Icon(Icons.view_list, color: Colors.green),
                  SizedBox(
                    width: 6,
                  ),
                  Text('View Planning',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}
