import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VTextField extends StatefulWidget {
  VTextField({Key? key, this.width, this.height, this.index, this.text,this.isEnable = false})
      : super(key: key);

  final double? width;
  final double? height;
  int? index;
  String? text;
  bool? isEnable;

  @override
  State<VTextField> createState() => _VTextFieldState();
}

class _VTextFieldState extends State<VTextField> {
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller!.text = widget.text ?? '';

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff6C6B70),
      ),
      child: TextFormField(
        controller: controller!,
        enabled: widget.isEnable,
        onTap: () {},
        decoration: InputDecoration(
          prefixIcon: widget.index! % 2 == 0
              ? const Icon(
                  Icons.trending_down,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.trending_up,
                  color: Colors.red,
                ),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

