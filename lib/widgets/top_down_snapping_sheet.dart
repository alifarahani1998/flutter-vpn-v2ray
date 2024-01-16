import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class TopDownSnappingSheet extends StatefulWidget {
  final SnappingSheetController controller;
  final TextEditingController tokenController;
  TopDownSnappingSheet(
      {required this.controller, required this.tokenController});

  @override
  State<TopDownSnappingSheet> createState() => _TopDownSnappingSheetState();
}

class _TopDownSnappingSheetState extends State<TopDownSnappingSheet> {
  late bool qrVisibility;

  @override
  void initState() {
    qrVisibility = !Global.shPreferences.containsKey(TOKEN);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                maskDownLeft,
                color: baseColor,
              ),
              Image.asset(
                maskRight,
                color: baseColor,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                moodiboom,
                style: TextStyle(
                    color: baseColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 56,
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  padding: EdgeInsets.fromLTRB(16, 5, 0, 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: baseViewColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ImageFiltered(
                        imageFilter: Global.shPreferences.containsKey(TOKEN)
                            ? ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0)
                            : ImageFilter.blur(),
                        child: TextField(
                          onTap: () {
                            setState(() {
                              qrVisibility = false;
                            });
                            widget.controller.snapToPosition(
                              SnappingPosition.factor(
                                snappingCurve: Curves.elasticOut,
                                snappingDuration: Duration(milliseconds: 1750),
                                positionFactor: 0.15,
                              ),
                            );
                          },
                          onSubmitted: (value) =>
                              setState(() => qrVisibility = value.isEmpty),
                          controller: widget.tokenController,
                          readOnly: Global.shPreferences.containsKey(TOKEN),
                          // inputFormatters: [
                          //   LengthLimitingTextInputFormatter(
                          //       25), //n is maximum number of characters you want in textfield
                          // ],
                          decoration: new InputDecoration.collapsed(
                              hintText: 'Enter your token',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor)),
                        ),
                      ),
                      Visibility(
                        visible: qrVisibility,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, QR_SCANNER_PAGE),
                                child: SvgPicture.asset(
                                  qr_svg,
                                  color: whiteColor,
                                ),
                              ),
                            )),
                      )
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
