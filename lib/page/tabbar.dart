import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final Color valueColor;
  TextEditingController toggleValueController;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    required this.toggleValueController,
    this.backgroundColor = const Color(0xFF434343),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.valueColor = Colors.white,
  });
  @override
  // ignore: library_private_types_in_public_api
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool initialPosition = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.05,
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 8,
              height: MediaQuery.of(context).size.height * 0.48,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular( width * 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  widget.values.length,
                      (index) => Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50.0),
                    child: Center(
                      child: Text(
                        widget.values[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.valueColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
            initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.46,
              height: MediaQuery.of(context).size.width * 0.48,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  fontSize: 14,
                  color: widget.textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}