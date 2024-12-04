import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Format {
  DateTime? formatDate(String? date) {
    if (date != null && date != '') {
      return DateFormat('dd/MM/yyyy').parse(date);
    } else {
      return null;
    }
  }

  TimeOfDay? formatTime(String? time) {
    if (time != null && time != '') {
      return TimeOfDay(
        hour: int.parse(time.split(':')[0]), 
        minute: int.parse(time.split(':')[1]),
      );
    } else {
      return null;
    }
  }

  String reformatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else {
      return '';
    }
  }

  String reformatTime(TimeOfDay? time) {
    if (time != null) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '';
    }
  }

  DateTime? dateTime(String date, String time) {
    return DateTime(
      int.parse(date.substring(4, 8)),
      int.parse(date.substring(3, 4)),
      int.parse(date.substring(0, 2)),
      int.parse(time.substring(0, 2)),
      int.parse(time.substring(2, 4)),
      int.parse(time.substring(4, 6)),
    );
  }

  Map<String, dynamic> extractDateTimeAndYear(String bopmId) {
    int cityCodeLength = bopmId[1].contains(RegExp(r'\d')) ? 2 : 1;

    var date = bopmId.substring(cityCodeLength + 3, cityCodeLength + 11);
    var time = bopmId.substring(cityCodeLength + 11, cityCodeLength + 17);
    var year = date.substring(4, 8);

    DateTime dateTime = Format().dateTime(date, time)!;

    return {
      'dateHour': Timestamp.fromDate(dateTime),
      'year': year,
    };
  }
}
