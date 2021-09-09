import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'cle_function/create_cle.dart';
import 'cle_function/show_list_location.dart';

class ClePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Clé';

    return MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(pageTitle),
        ),
        body: ShowListLocation(),
      ),
    );
  }
}
