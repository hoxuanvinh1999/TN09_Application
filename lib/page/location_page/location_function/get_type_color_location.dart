import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Color getTypeColorLocation(String type) {
  Color color = Colors.red;
  switch (type) {
    case 'Resto':
      color = Colors.brown;
      break;
    case 'Crous':
      color = Colors.green;
      break;
    case 'Cantine':
      color = Colors.teal;
      break;
    case 'Autre':
      color = Colors.black;
      break;
    default:
      color = Colors.red;
      break;
  }
  return color;
}
