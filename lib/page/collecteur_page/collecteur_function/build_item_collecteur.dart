import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/collecteur_page/collecteur_function/show_delete_dialog_collecteur.dart';
import 'package:tn09_app_demo/page/collecteur_page/collecteur_function/update_collecteur.dart';

Widget buildItemCollecteur(
    {required BuildContext context, required Map collecteur}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(10),
    height: 200,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              collecteur['nomCollecteur'],
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
              Icons.person,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Prenom: ' + collecteur['prenomCollecteur'],
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
              Icons.calendar_today_rounded,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Date de Naissance: ' + collecteur['datedeNaissance'],
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 6,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateCollecteur(
                            collecteurKey: collecteur['key'])));
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
                showDeleteDialogCollecteur(
                    context: context, collecteur: collecteur);
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
                /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewInformationPlanning(
                            collecteurKey: collecteur['key'])));
                */
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
                  Text('View Planning',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
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
