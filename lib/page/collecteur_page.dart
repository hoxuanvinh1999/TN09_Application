import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

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
        body: const CreateCollecteurForm(),
      ),
    );
  }
}

class CreateCollecteurForm extends StatefulWidget {
  const CreateCollecteurForm({Key? key}) : super(key: key);

  @override
  CreateCollecteurFormState createState() {
    return CreateCollecteurFormState();
  }
}

class CreateCollecteurFormState extends State<CreateCollecteurForm> {
  final _collectuerKey = GlobalKey<FormState>();
  String nomcollecteur = '';
  String prenomcollecteur = '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _collectuerKey created above.
    return Form(
      key: _collectuerKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Nom du collecteur',
              labelText: 'Nom',
            ),

            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some information';
              } else {
                nomcollecteur = value;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.add),
              hintText: 'Prenom du collecteur',
              labelText: 'Prenom',
            ),

            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some information';
              } else {
                prenomcollecteur = value;
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_collectuerKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  savecollecteur();
                }
              },
              child: const Text('Creér Collecteur'),
            ),
          ),
        ],
      ),
    );
  }

  void savecollecteur() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('En train de Creér Collecteur')),
    );
  }
}
