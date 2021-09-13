import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/show_etape.dart';

class EtapePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Etape';

    return MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(pageTitle),
        ),
        body: ShowEtape(),
      ),
    );
  }
}
