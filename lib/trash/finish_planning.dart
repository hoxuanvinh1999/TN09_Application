import 'package:flutter/material.dart';

class FinishPlanning extends StatefulWidget {
  @override
  _FinishPlanningState createState() => _FinishPlanningState();
}

class _FinishPlanningState extends State<FinishPlanning> {
  @override
  Widget build(BuildContext context) => Scaffold(
          appBar: AppBar(
        title: Text('Finish Planning'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ));
}
