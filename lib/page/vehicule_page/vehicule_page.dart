import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/show_etape.dart';
import 'package:tn09_app_demo/page/vehicule_page/vehicule_function/show_vehicule.dart';

class VehiculePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Vehicule';

    return MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(pageTitle),
        ),
        body: ShowVehicule(),
      ),
    );
  }
}
