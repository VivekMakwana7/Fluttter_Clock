import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StatusDetail extends StatelessWidget {
  bool? isWorkDone;
  String? effectiveHour,reamingTime,totalHour;

  StatusDetail({
    Key? key,
    this.isWorkDone,
    this.effectiveHour,this.reamingTime,this.totalHour
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            isWorkDone!
                ? "Your Time is Over, So Please Go ASAP...!"
                : "Ohh Sorry, Your time is not over",
            style: const TextStyle(
                color: Color(0xFF9F9EA3),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ),
        isWorkDone!
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  isWorkDone!
                      ? ""
                      : "Effective Hour : $effectiveHour",
                  style: const TextStyle(
                      color: Color(0xFF9F9EA3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
        isWorkDone!
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  isWorkDone!
                      ? ""
                      : "Remaing Time: $reamingTime",
                  style: const TextStyle(
                      color: Color(0xFF9F9EA3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
        isWorkDone!
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  isWorkDone!
                      ? ""
                      : "Total Time: $totalHour",
                  style: const TextStyle(
                      color: Color(0xFF9F9EA3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
        isWorkDone!
            ? SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/run2.json'),
              )
            : SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/workdone.json'),
              ),
      ],
    );
  }
}
