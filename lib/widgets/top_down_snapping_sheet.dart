import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:moodiboom/controllers/authorization_controller.dart';
import 'package:moodiboom/controllers/connection_controller.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class TopDownSnappingSheet extends StatefulWidget {
  final SnappingSheetController controller;
  final TextEditingController tokenController;
  final bool isAboveSheetOpen;
  final FlutterV2ray flutterV2ray;
  TopDownSnappingSheet(
      {required this.controller,
      required this.tokenController,
      required this.isAboveSheetOpen,
      required this.flutterV2ray});

  @override
  State<TopDownSnappingSheet> createState() => _TopDownSnappingSheetState();
}

class _TopDownSnappingSheetState extends State<TopDownSnappingSheet> {
  late bool qrVisibility;
  late bool qrCodeScanned;

  @override
  void initState() {
    super.initState();
    qrVisibility = !Global.shPreferences.containsKey(TOKEN);
    qrCodeScanned = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorizationController, AuthorizationStates>(
      listener: (context, state) async {
        if (state is AuthorizationStatesAuthorized) {
          qrVisibility = false;
          if (qrCodeScanned) {
            context
              .read<ConnectionController>()
              .requestVPNPermission(widget.flutterV2ray);
            await Future.delayed(const Duration(seconds: 2));
            context
                .read<ConnectionController>()
                .connect(Global.connectionJsonModel, widget.flutterV2ray);
            qrCodeScanned = false;
          }
        } else
          qrVisibility = true;
      },
      builder: (context, state) {
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
                  SvgPicture.asset(
                    logoText,
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 56,
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: baseViewColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageFiltered(
                            imageFilter:
                                Global.shPreferences.containsKey(TOKEN) &&
                                        !widget.isAboveSheetOpen
                                    ? ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0)
                                    : ImageFilter.blur(),
                            child: Container(
                              padding: EdgeInsets.only(right: state is AuthorizationStatesAuthorized ? 0 : 40),
                              child: TextField(
                                onTap: () => widget.controller.snapToPosition(
                                  SnappingPosition.factor(
                                    snappingCurve: Curves.elasticOut,
                                    snappingDuration:
                                        const Duration(milliseconds: 200),
                                    positionFactor: 0.15,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: state is AuthorizationStatesError
                                        ? errorColor
                                        : whiteColor),
                                textAlign:
                                    state is AuthorizationStatesAuthorized
                                        ? TextAlign.center
                                        : TextAlign.start,
                                controller: widget.tokenController,
                                readOnly:
                                    Global.shPreferences.containsKey(TOKEN),
                                decoration: new InputDecoration.collapsed(
                                    hintText: 'Enter your token',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: qrVisibility,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () => _scan().then((value) {
                                  if (value!.isNotEmpty) {
                                    qrCodeScanned = true;
                                    context
                                        .read<AuthorizationController>()
                                        .getConnectionConfig(value);
                                  }
                                }),
                                child: SvgPicture.asset(
                                  qrSvg,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<String?> _scan() async {
    if (await Permission.camera.request().isGranted) {
      String? barcode = await scanner.scan();
      return barcode;
    }
    return '';
  }
}
