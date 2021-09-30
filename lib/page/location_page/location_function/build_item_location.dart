import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/view_information_cle.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/location_page/location_function/get_type_color_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/show_delete_dialog_location.dart';
import 'package:tn09_app_demo/widget/border_decoration.dart';
import 'create_location.dart';
import 'update_location.dart';

Widget buildItemLocation(
    {required BuildContext context, required Map location}) {
  Color typeColor = getTypeColorLocation(location['type']);
  return Container(
    decoration: buildBorderDecoration(),
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    padding: EdgeInsets.all(10),
    height: 250,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
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
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
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
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
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
                  fontSize: 16, color: typeColor, fontWeight: FontWeight.w600),
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
                  fontSize: 16, color: typeColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Icon(
              Icons.restore_from_trash_outlined,
              color: typeColor,
              size: 20,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              location['nombredebac'],
              style: TextStyle(
                  fontSize: 16, color: typeColor, fontWeight: FontWeight.w600),
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
                        builder: (_) =>
                            ViewContact(contactKey: location['contact_key'])));
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
                        builder: (_) => UpdateLocation(location: location)));
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
                showDeleteDialogLocation(context: context, location: location);
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
                        builder: (_) =>
                            ViewInformationCle(locationKey: location['key'])));
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
}
