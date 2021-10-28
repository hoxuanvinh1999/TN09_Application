import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String getDuration({required String time}) {
  String result = '';
  TimeOfDay now = TimeOfDay.now();
  int hour = now.hour - int.parse(time.substring(0, 2));
  int minute = 0;
  if (now.minute - int.parse(time.substring(3, 5)) < 0) {
    minute = now.minute - int.parse(time.substring(3, 5)) + 60;
  } else {
    minute = now.minute - int.parse(time.substring(3, 5));
  }
  if (hour < 10) {
    result += '0';
  }
  result += hour.toString();
  result += ':';
  if (minute < 10) {
    result += '0';
  }
  result += minute.toString();
  return result;
}
