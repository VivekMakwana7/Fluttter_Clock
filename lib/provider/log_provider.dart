import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogProvider extends ChangeNotifier {
  List logList = [];

  Duration? effectiveHour;
  Duration? reamingTime;
  Duration? whenLeaveTime;
  Duration? partialTime;
  Duration? halfDay;

  Duration? totalHour;

  bool isCalculate = false;
  bool isPartial = false;
  bool isHalfDay = false;

  bool isWorkDone = false;

  Timer? timer;

  String? errorMessage = '';

  TextEditingController autoTextController = TextEditingController();
  TextEditingController partialTextController = TextEditingController();
  Duration compHour = const Duration(hours: 8, minutes: 20, seconds: 00);

  recheck() {
    autoTextController.text = '';
    logList.clear();
    isCalculate = false;
    isPartial = false;
    isHalfDay = false;
    isWorkDone = false;
    partialTextController.text = "";
    halfDay = Duration.zero;
    partialTime = Duration.zero;
    errorMessage = '';
    compHour = const Duration(hours: 8, minutes: 20, seconds: 00);
    timer?.cancel();
    notifyListeners();
  }

  //#region Auto
  autoCalculateTime(BuildContext context) {
    DateTime now = DateTime.now();
    logList.clear();

    compHour = getCompTime();

    try {
      if (autoTextController.text.contains('AM') ||
          autoTextController.text.contains('PM')) {
        //#region AM?PM
        ///Split String into List By M char
        List<String> result = autoTextController.text.split('M');
        for (int i = 0; i < result.length; i++) {
          if (result[i].trim() != '') {
            logList.add('${result[i].trim()}M');
          } else {}
        }

        ///Store 24 Hour time Value
        List list = [];
        for (int i = 0; i < logList.length; i++) {
          if (logList[i] == "ISSINGM") {
            DateTime now = DateTime.now();
            logList[i] = "${now.hour}:${now.minute}";
            list.add("${now.hour}:${now.minute}:${now.second}");
          } else {
            DateTime time = DateFormat("hh:mm:ss a").parse(logList[i]);

            list.add('${time.hour}:${time.minute}:${time.second}');
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
          var format = DateFormat("HH:mm:ss");
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
        var format = DateFormat("HH:mm:ss");
        var one = format.parse(list.first);
        var two = format.parse(list.last);

        totalHour = two.difference(one);

        ///Remaining Time
        DateTime effectiveHourDateTime = dateTimeFunction(effectiveHour!);
        DateTime compHourDateTime = dateTimeFunction(compHour);

        reamingTime = compHourDateTime.difference(effectiveHourDateTime);

        String hour = DateFormat('hh').format(DateTime.now().add(reamingTime!));
        String minute = DateFormat('mm').format(DateTime.now().add(reamingTime!));
        String second = DateFormat('ss').format(DateTime.now().add(reamingTime!));

        whenLeaveTime = Duration(hours: int.parse(hour),minutes: int.parse(minute),seconds: int.parse(second));

        if (compHour.compareTo(effectiveHour!) <= -1) {
          isWorkDone = true;
        } else {
          isWorkDone = false;
          timer = Timer.periodic(
              const Duration(seconds: 1), (Timer t) => autoReflect());
        }

        isCalculate = true;

        //#endregion
      } else {
        //#region 24 Hour
        logList.clear();
        String s = autoTextController.text.trim().replaceAll(" ", "");

        List<String> result = s.split(':');

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
          chunks.add(logList.sublist(i,
              i + chunkSize > logList.length ? logList.length : i + chunkSize));
        }

        ///Hour Difference List
        List<Duration> hourDiff = [];
        for (int i = 0; i < chunks.length; i++) {
          var format = DateFormat("HH:mm:ss");
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
        var format = DateFormat("HH:mm:ss");
        var one = format.parse(logList.first);
        var two = format.parse(logList.last);

        totalHour = two.difference(one);

        ///Remaining Time

        DateTime effectiveHourDateTime = dateTimeFunction(effectiveHour!);
        DateTime compHourDateTime = dateTimeFunction(compHour);

        reamingTime = compHourDateTime.difference(effectiveHourDateTime);

        String hour = DateFormat('hh').format(DateTime.now().add(reamingTime!));
        String minute = DateFormat('mm').format(DateTime.now().add(reamingTime!));
        String second = DateFormat('ss').format(DateTime.now().add(reamingTime!));

        whenLeaveTime = Duration(hours: int.parse(hour),minutes: int.parse(minute),seconds: int.parse(second));

        if (compHour.compareTo(effectiveHour!) <= -1) {
          isWorkDone = true;
        } else {
          isWorkDone = false;
          timer = Timer.periodic(
              const Duration(seconds: 1), (Timer t) => autoReflect());
        }

        isCalculate = true;

        //#endregion
      }
    } catch (e) {
      errorMessage = 'Invalid Format \nPlease Enter valid Time Log';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xff6C6B70),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(
              horizontal: kIsWeb ? 200 : 25, vertical: 10),
          content: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    notifyListeners();
  }

  //#endregion

  changeState() {
    notifyListeners();
  }

  //#region CheckBox
  changePartial(bool? value) {
    isPartial = value!;
    notifyListeners();
  }

  changeHalfDay(bool? value) {
    isHalfDay = value!;
    notifyListeners();
  }

  //#endregion

  //#region Subtrack Minus one Second
  autoReflect() {
    DateTime now = DateTime.now();
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
    DateTime totalHourDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      totalHour!.inHours.remainder(60),
      totalHour!.inMinutes.remainder(60),
      totalHour!.inSeconds.remainder(60),
    );

    DateTime effectiveHourFinal =
        effectiveHourDateTime.add(const Duration(seconds: 1));

    effectiveHour = Duration(
        hours: effectiveHourFinal.hour,
        minutes: effectiveHourFinal.minute,
        seconds: effectiveHourFinal.second);

    DateTime totalHourFinal = totalHourDateTime.add(const Duration(seconds: 1));

    totalHour = Duration(
        hours: totalHourFinal.hour,
        minutes: totalHourFinal.minute,
        seconds: totalHourFinal.second);

    reamingTime = compHourDateTime.difference(effectiveHourDateTime);

    if(reamingTime! <= Duration.zero){
      isWorkDone = true;
    }
  }

  //#endregion

  //#region DateTime Funcation
  DateTime dateTimeFunction(Duration duration) {
    DateTime now = DateTime.now();
    DateTime time = DateTime(
      now.year,
      now.month,
      now.day,
      duration.inHours.remainder(60),
      duration.inMinutes.remainder(60),
      duration.inSeconds.remainder(60),
    );
    return time;
  }

  //#endregion

  //#region Comp Time
  Duration getCompTime() {
    Duration duration = const Duration();

    partialTime = Duration(
        minutes: partialTextController.text != ""
            ? int.parse(partialTextController.text)
            : 0,
        seconds: 0,
        hours: 0);
    halfDay = isHalfDay
        ? const Duration(minutes: 10, seconds: 0, hours: 4)
        : const Duration();

    DateTime totalTime = dateTimeFunction(compHour);

    if (isPartial) {
      duration = Duration(
          hours: totalTime.subtract(partialTime!).hour,
          minutes: totalTime.subtract(partialTime!).minute,
          seconds: totalTime.subtract(partialTime!).second);
    } else if (isHalfDay) {
      duration = Duration(
          hours: totalTime.subtract(halfDay!).hour,
          minutes: totalTime.subtract(halfDay!).minute,
          seconds: totalTime.subtract(halfDay!).second);
    } else {
      duration = compHour;
    }

    return duration;
  }
//#endregion

}
