import 'package:flutter/material.dart';

import 'contact_function/show_contact.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const pageTitle = 'Contact';

    return MaterialApp(
      title: pageTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(pageTitle),
        ),
        body: ShowContact(),
      ),
    );
  }
}
