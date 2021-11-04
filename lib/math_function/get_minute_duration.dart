import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String getMinuteDuration({required String time}) {
  int result = 0;
  TimeOfDay now = TimeOfDay.now();
  int hour = now.hour - int.parse(time.substring(0, 2));
  int minute = now.minute - int.parse(time.substring(3, 5));
  if (minute < 0) {
    minute += 60;
    hour -= 1;
  }
  result += hour * 60 + minute;
  return result.toString();
}
