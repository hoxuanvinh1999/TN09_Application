import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';

class CreatePlanning extends StatefulWidget {
  @override
  _CreatePlanningState createState() => _CreatePlanningState();
}

class _CreatePlanningState extends State<CreatePlanning> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Create Planning'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(
                'New Start Etape',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return CreateEtape(reason: 'createPlanning');
                }),
              ),
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 12,
            ),
            RaisedButton(
              child: Text(
                'Use available Etape',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: (
                  //Will update later
                  ) {},
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ));
}
