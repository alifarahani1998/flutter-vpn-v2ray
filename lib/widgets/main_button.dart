import 'package:flutter/material.dart';
import 'package:moodiboom/utils/constants.dart';

class MainButton extends StatelessWidget {
  final String text;
  final bool isWaiting;
  final Function onPressed;
  final Color color;

  MainButton(
      {required this.isWaiting,
      required this.onPressed,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onPressed(),
        child: Container(
            alignment: Alignment.center,
            height: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: baseViewColor),
            child: isWaiting
                ? CircularProgressIndicator(
                    color: baseColor,
                  )
                : Text(
                    text,
                    style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  )));
  }
}
