import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

Widget buildspeacial(
    {required BuildContext context,
    required String nomLocationEtape,
    required String addressLocationEtape,
    required String materialEtape,
    required String nombredebac}) {
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
