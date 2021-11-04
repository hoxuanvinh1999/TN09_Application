import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

InputDecoration buildInputDecoration(String hint, String iconPath, Icon icon) {
  return InputDecoration(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(252, 252, 252, 1))),
      hintText: hint,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(151, 151, 151, 1))),
      hintStyle:
          TextStyle(fontSize: 16, color: Color.fromRGBO(159, 199, 205, 1)),
      icon: iconPath != '' ? Image.asset(iconPath) : icon,
      errorStyle: TextStyle(color: Color.fromRGBO(232, 48, 11, 1)),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 218, 87, 1))),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(240, 47, 6, 1))));
}
