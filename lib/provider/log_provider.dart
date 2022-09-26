import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class LogProvider extends ChangeNotifier {
  List logList = [];
  List fieldList = [];

  Duration? effectiveHour;
  Duration? reamingTime;

  int tabValue = 0;

  var totalHour;

  bool isCalculate = false;

  bool isWorkDone = false;

  TextEditingController autoTextController = TextEditingController();

  recheck() {
    autoTextController.text = '';
    logList.clear();
    fieldList.clear();
    isCalculate = false;
    notifyListeners();
  }

  //#region Manual
  calculateTime() {
    DateTime now = DateTime.now();

    int length = logList.length;

    // logList = fieldList;

    if (length % 2 == 1) {
      DateTime now = DateTime.now();
      logList.add("${now.hour}:${now.minute}");
    }

    List chunks = [];

    int chunkSize = 2;

    for (int i = 0; i < logList.length; i += chunkSize) {
      chunks.add(logList.sublist(
          i, i + chunkSize > logList.length ? logList.length : i + chunkSize));
    }

    List<Duration> hourDiff = [];

    for (int i = 0; i < chunks.length; i++) {
      var format = DateFormat("HH:mm");
      var one = format.parse(chunks[i][0]);
      var two = format.parse(chunks[i][1]);
      hourDiff.add(two.difference(one));
    }

    effectiveHour = Duration.zero;

    for (int i = 0; i < hourDiff.length; i++) {
      effectiveHour = effectiveHour! + hourDiff[i];
    }

    var format = DateFormat("HH:mm");
    var one = format.parse(logList.first);
    var two = format.parse(logList.last);

    totalHour = two.difference(one);

    Duration compHour = const Duration(hours: 8, minutes: 20, seconds: 00);

    DateTime effectiveHourDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      effectiveHour!.inHours.remainder(60),
      effectiveHour!.inMinutes.remainder(60),
      effectiveHour!.inSeconds.remainder(60),
    );

    DateTime compHourDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      compHour.inHours.remainder(60),
      compHour.inMinutes.remainder(60),
      compHour.inSeconds.remainder(60),
    );

    reamingTime = compHourDateTime.difference(effectiveHourDateTime);

    if (compHour.compareTo(effectiveHour!) <= -1) {
      isWorkDone = true;
    } else {
      isWorkDone = false;
    }

    isCalculate = true;
    notifyListeners();
  }

  //#endregion

  //#region Auto
  autoCalculateTime() {
    DateTime now = DateTime.now();
    logList.clear();

    if (autoTextController.text.contains('AM') ||
        autoTextController.text.contains('PM')) {
      ///Split String into List By M char
      List<String> result = autoTextController.text.split('M');
      for (int i = 0; i < result.length; i++) {
        if (result[i] != '') {
          logList.add('${result[i]}M');
        }
      }

      ///Store 24 Hour time Value
      List list = [];
      for (int i = 0; i < logList.length; i++) {
        if (logList[i] == "ISSINGM") {
          DateTime now = DateTime.now();
          logList[i] = "${now.hour}:${now.minute}";
          list.add("${now.hour}:${now.minute}");
        } else {
          DateTime time = DateFormat("hh:mm:ss a").parse(logList[i]);

          list.add('${time.hour}:${time.minute}');
        }
      }

      ///Seperate 2 2 List
      List chunks = [];
      int chunkSize = 2;
      for (int i = 0; i < list.length; i += chunkSize) {
        chunks.add(list.sublist(
            i, i + chunkSize > list.length ? list.length : i + chunkSize));
      }

      ///Hour Difference List
      List<Duration> hourDiff = [];
      for (int i = 0; i < chunks.length; i++) {
        var format = DateFormat("HH:mm");
        var one = format.parse(chunks[i][0]);
        var two = format.parse(chunks[i][1]);
        hourDiff.add(two.difference(one));
      }

      ///Get Effective Time
      effectiveHour = Duration.zero;
      for (int i = 0; i < hourDiff.length; i++) {
        effectiveHour = effectiveHour! + hourDiff[i];
      }

      ///Total Time
      var format = DateFormat("HH:mm");
      var one = format.parse(logList.first);
      var two = format.parse(logList.last);

      totalHour = two.difference(one);

      ///Remaining Time
      Duration compHour = const Duration(hours: 8, minutes: 20, seconds: 00);
      DateTime effectiveHourDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        effectiveHour!.inHours.remainder(60),
        effectiveHour!.inMinutes.remainder(60),
        effectiveHour!.inSeconds.remainder(60),
      );
      DateTime compHourDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        compHour.inHours.remainder(60),
        compHour.inMinutes.remainder(60),
        compHour.inSeconds.remainder(60),
      );
      reamingTime = compHourDateTime.difference(effectiveHourDateTime);

      if (compHour.compareTo(effectiveHour!) <= -1) {
        isWorkDone = true;
      } else {
        isWorkDone = false;
      }

      isCalculate = true;
    } else {
      logList.clear();
      String s = autoTextController.text;

      List<String> result = s.split(':');

      log('result : $result');
      List stringList = [];

      for (int i = 0; i < result.length; i++) {
        if (i % 2 == 0 && i != 0) {
          String f = result[i].substring(0, 2);
          String l = result[i].substring(2, 4);
          stringList.add(f);
          stringList.add(l);
        } else {
          stringList.add(result[i]);
        }
      }

      List list = [];
      int chunkSize3 = 3;
      for (int i = 0; i < stringList.length; i += chunkSize3) {
        list.add(stringList.sublist(
            i,
            i + chunkSize3 > stringList.length
                ? stringList.length
                : i + chunkSize3));
      }

      String time = '';
      for (int i = 0; i < list.length; i++) {
        if (list[i][0] != 'MI') {
          time = '${list[i][0]}:${list[i][1]}:${list[i][2]}';
          logList.add(time);
        } else {
          DateTime now = DateTime.now();
          logList.add("${now.hour}:${now.minute}:${now.second}");
        }
      }

      ///Seperate 2 2 List
      List chunks = [];
      int chunkSize = 2;
      for (int i = 0; i < logList.length; i += chunkSize) {
        chunks.add(logList.sublist(
            i, i + chunkSize > logList.length ? logList.length : i + chunkSize));
      }

      ///Hour Difference List
      List<Duration> hourDiff = [];
      for (int i = 0; i < chunks.length; i++) {
        var format = DateFormat("HH:mm");
        var one = format.parse(chunks[i][0]);
        var two = format.parse(chunks[i][1]);
        hourDiff.add(two.difference(one));
      }

      ///Get Effective Time
      effectiveHour = Duration.zero;
      for (int i = 0; i < hourDiff.length; i++) {
        effectiveHour = effectiveHour! + hourDiff[i];
      }

      ///Total Time
      var format = DateFormat("HH:mm");
      var one = format.parse(logList.first);
      var two = format.parse(logList.last);

      totalHour = two.difference(one);

      ///Remaining Time
      Duration compHour = const Duration(hours: 8, minutes: 20, seconds: 00);
      DateTime effectiveHourDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        effectiveHour!.inHours.remainder(60),
        effectiveHour!.inMinutes.remainder(60),
        effectiveHour!.inSeconds.remainder(60),
      );
      DateTime compHourDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        compHour.inHours.remainder(60),
        compHour.inMinutes.remainder(60),
        compHour.inSeconds.remainder(60),
      );
      reamingTime = compHourDateTime.difference(effectiveHourDateTime);

      if (compHour.compareTo(effectiveHour!) <= -1) {
        isWorkDone = true;
      } else {
        isWorkDone = false;
      }

      isCalculate = true;
    }

    notifyListeners();
  }

  //#endregion

  changeState() {
    notifyListeners();
  }

  addNewLog(String time, int index) {
    if (index == 0) {
      fieldList.clear();
      fieldList.add(time);
      logList.add(time);
    } else {
      fieldList.add(time);
      logList.add(time);
    }

    notifyListeners();
  }

  changeTab(int value) {
    recheck();
    tabValue = value;
    notifyListeners();
  }
}
