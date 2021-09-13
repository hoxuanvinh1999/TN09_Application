import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Color getTypeColorCle(String type) {
  Color color = Colors.red;
  switch (type) {
    case 'Cle':
      color = Colors.brown;
      break;
    case 'Badge':
      color = Colors.green;
      break;
    case 'Carte':
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
