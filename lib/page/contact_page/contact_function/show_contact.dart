import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/location_page/location_function/delete_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/create_location.dart';
import 'create_contact.dart';
import 'update_contact.dart';
import 'view_list_location.dart';

class ShowContact extends StatefulWidget {
  @override
  _ShowContactState createState() => _ShowContactState();
}

class _ShowContactState extends State<ShowContact> {
  Query _refContact = FirebaseDatabase.instance
      .reference()
      .child('Contact')
      .orderByChild('nomContact');
  DatabaseReference referenceContact =
      FirebaseDatabase.instance.reference().child('Contact');

  Widget _buildContactItem({required Map contact}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      height: 380,
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
                contact['nomContact'],
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
              SizedBox(
                width: 26,
              ),
              Text(
                'Prenom: ' + contact['prenomContact'],
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
                Icons.calendar_today,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Date de Création: ' + contact['datecreeContact'],
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
                Icons.location_on,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Adress: ' + contact['addressContact'],
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
                Icons.phone,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Phone: ' + contact['telephoneContact'],
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
                Icons.contact_mail,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Mail: ' + contact['mailContact'],
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
                Icons.receipt,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Argent à payer: ' + contact['payerContact'],
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
                Icons.house,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Nombre des locations: ' + contact['nombredelocation'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  //print('key before send ${location['key']}');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              CreateLocation(contactKey: contact['key'])));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Add Location',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                  //print('key before send ${location['key']}');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              UpdateContact(contactKey: contact['key'])));
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
                  _showDeleteDialog(contact: contact);
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
                  //print('key before send ${location['key']}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ViewListLocation(contactKey: contact['key'])));
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
                    Text('View Location',
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

  _showDeleteDialog({required Map contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${contact['nomcontact']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    String contact_key = contact['key'];
                    if (contact['nombredelocation'] != '0') {
                      deleteLocation(contact_key: contact_key);
                    }
                    referenceContact
                        .child(contact['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Contact'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _refContact,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map contact = snapshot.value;
            contact['key'] = snapshot.key;
            return _buildContactItem(contact: contact);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return CreateContact();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
