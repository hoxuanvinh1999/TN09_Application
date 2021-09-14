import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/collecteur_page/collecteur_function/show_collecteur.dart';

class CollecteurPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Collecteur';

    return MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(pageTitle),
        ),
        body: ShowCollecteur(),
      ),
    );
  }
}
