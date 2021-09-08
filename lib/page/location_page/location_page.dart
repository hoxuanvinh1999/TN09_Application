import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import './location_function/show_location.dart';
import './location_function/create_location.dart';
import './location_function/update_location.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Location';

    return MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(pageTitle),
        ),
        body: ShowLocation(),
      ),
    );
  }
}
