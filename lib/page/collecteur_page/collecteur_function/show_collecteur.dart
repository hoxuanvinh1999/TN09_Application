import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/collecteur_page/collecteur_function/build_item_collecteur.dart';
import 'package:tn09_app_demo/page/collecteur_page/collecteur_function/create_collecteur.dart';

class ShowCollecteur extends StatefulWidget {
  @override
  _ShowCollecteurState createState() => _ShowCollecteurState();
}

class _ShowCollecteurState extends State<ShowCollecteur> {
  Query _refCollecteur = FirebaseDatabase.instance
      .reference()
      .child('Collecteur')
      .orderByChild('nomCollecteur');
  DatabaseReference referenceCollecteur =
      FirebaseDatabase.instance.reference().child('Collecteur');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Collecteur'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _refCollecteur,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map collecteur = snapshot.value;
            collecteur['key'] = snapshot.key;
            return buildItemCollecteur(
                context: context, collecteur: collecteur);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return CreateCollecteur();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
