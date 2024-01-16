import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodiboom/utils/constants.dart';

class DefaultGrabbing extends StatelessWidget {
  final Color color;
  final bool reverse;
  final bool isAboveSnappingSheet;

  const DefaultGrabbing(
      {Key? key,
      this.color = blackColor,
      this.reverse = false,
      this.isAboveSnappingSheet = true})
      : super(key: key);

  BorderRadius _getBorderRadius() {
    var radius = Radius.circular(50.0);
    return BorderRadius.only(
      topLeft: reverse ? Radius.zero : radius,
      topRight: reverse ? Radius.zero : radius,
      bottomLeft: reverse ? radius : Radius.zero,
      bottomRight: reverse ? radius : Radius.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 10,
            color: blackColor.withOpacity(0.15),
          )
        ],
        borderRadius: _getBorderRadius(),
        color: this.color,
      ),
      child: Transform.rotate(
        angle: reverse ? pi : 0,
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.5),
              child: _GrabbingIndicator(
                iSAboveSnappingSheet: isAboveSnappingSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrabbingIndicator extends StatelessWidget {
  final bool iSAboveSnappingSheet;

  _GrabbingIndicator({this.iSAboveSnappingSheet = true});

  @override
  Widget build(BuildContext context) {
    return iSAboveSnappingSheet
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: whiteColor,
            ),
            height: 5,
            width: 75,
          )
        : SvgPicture.asset(
            arrow_up,
            width: 40,
          );
  }
}
