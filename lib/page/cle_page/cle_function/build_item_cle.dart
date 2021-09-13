import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/get_type_color_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/reduce_number_of_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/show_delete_dialog_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/update_cle.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_location.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';

Widget buildItemCle({required BuildContext context, required Map cle}) {
  Color typeColor = getTypeColorCle(cle['type']);
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(10),
    height: 130,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.note,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              cle['noteCle'],
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
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
              cle['type'],
              style: TextStyle(
                  fontSize: 16, color: typeColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 10,
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
                        builder: (_) => UpdateCle(cleKey: cle['key'])));
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
                  Text('Edit Cle',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showDeleteDialogCle(context: context, cle: cle);
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
          height: 10,
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
                            ViewLocation(locationKey: cle['location_key'])));
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
                  Text('View Location',
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
          ],
        )
      ],
    ),
  );
}
