import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/create_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/show_planning.dart';

class PlanningPage extends StatefulWidget {
  @override
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Planning'),
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
                      'Créer nouvelle planning',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return CreatePlanning();
                      }),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                    child: Text(
                      'View planning',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return ShowPlanning();
                      }),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return HomeScreen();
                      }),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )),
      );
}
