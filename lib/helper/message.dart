import 'dart:ui';

import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({Key? key, this.mess, this.color, this.fontSize})
      : super(key: key);

  final String? mess;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return mess != null
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              mess!,
              style: TextStyle(
                color: color ?? const Color(0xFF9F9EA3),
                fontSize: fontSize ?? 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontFeatures: const [
                   FontFeature.oldstyleFigures(),
                ],
              ),
            ),
          )
        : Container();
  }
}
