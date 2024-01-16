import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:moodiboom/controllers/authorization_controller.dart';
import 'package:moodiboom/controllers/connection_controller.dart';
import 'package:moodiboom/helpers/global.dart';
// import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:moodiboom/widgets/bottom_up_snapping_sheet.dart';
import 'package:moodiboom/widgets/default_grabbing.dart';
import 'package:moodiboom/widgets/dialogs.dart';
import 'package:moodiboom/widgets/top_down_snapping_sheet.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  MainPage();

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());
  late final FlutterV2ray flutterV2ray;
  TextEditingController _tokenController = new TextEditingController();
  final SnappingSheetController _snappingSheetControllerAbove =
      SnappingSheetController();
  late bool isAboveSheetOpen;
  late bool isBelowSheetOpen;

  @override
  void initState() {
    isAboveSheetOpen = false;
    isBelowSheetOpen = false;

    _tokenController.text = Global.shPreferences.containsKey(TOKEN)
        ? Global.shPreferences.getString(TOKEN)!
        : '';
    super.initState();
    flutterV2ray = FlutterV2ray(
      onStatusChanged: (status) {
        v2rayStatus.value = status;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _canConfirmToken() => _tokenController.text.isNotEmpty;

  void resetConfig() async {
    await Global.shPreferences.clear();
    context.read<ConnectionController>().disconnect(flutterV2ray);
    context.read<AuthorizationController>().emit(AuthorizationStatesInitial());
    _tokenController.clear();
    setState(() {});
  }


  Widget buttonRow(BuildContext context, AuthorizationStates state) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      color: blackColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => state is AuthorizationStatesAuthorized
                ? showDialog(context: context, builder: warningDialog).then((value) => value ? resetConfig() : null)
                : _canConfirmToken()
                    ? context
                        .read<AuthorizationController>()
                        .getConnectionJson(_tokenController.text)
                    : null,
            child: Container(
                alignment: Alignment.center,
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: baseViewColor),
                child: Text(
                  state is AuthorizationStatesAuthorized
                      ? 'Delete'
                      : 'Register',
                  style: TextStyle(
                      color: state is AuthorizationStatesAuthorized
                          ? errorColor
                          : whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
          ),
          InkWell(
            onTap: () async {
              if (state is AuthorizationStatesInitial) {
                final Uri url = Uri.parse('https://moodiboom.com');
                if (!await launchUrl(url))
                  throw Exception('Could not launch $url');
              } else
                null;
            },
            child: Container(
                height: 56,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: baseViewColor),
                child: Text(
                  state is AuthorizationStatesAuthorized
                      ? 'Renewal'
                      : 'Buy a token',
                  style: TextStyle(
                      color: baseColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorizationController, AuthorizationStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Container(
                      alignment: Alignment.center,
                      color: baseViewColor.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Text('status',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                          BlocBuilder<ConnectionController, ConnectingStates>(
                            builder: (context, connectionState) {
                              return Text(
                                  state is AuthorizationStatesError
                                      ? state.error
                                      : state is AuthorizationStatesInitial
                                          ? 'Not registered'
                                          : connectionState
                                                  is ConnectionStateInitial
                                              ? 'Disconnected'
                                              : connectionState
                                                      is ConnectionStateLoading
                                                  ? 'Connecting'
                                                  : 'Connected',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: state is AuthorizationStatesError
                                          ? errorColor
                                          : state is AuthorizationStatesInitial
                                              ? whiteColor
                                              : connectionState
                                                      is ConnectionStateInitial
                                                  ? errorColor
                                                  : connectionState
                                                          is ConnectionStateLoading
                                                      ? connectingColor
                                                      : baseColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700));
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                              onTap: _canConfirmToken()
                                  ? () => state is AuthorizationStatesAuthorized
                                      ? context
                                              .read<ConnectionController>()
                                              .state is ConnectionStateInitial
                                          ? context
                                              .read<ConnectionController>()
                                              .connect(
                                                  Global.connectionJsonModel,
                                                  flutterV2ray)
                                          : context
                                              .read<ConnectionController>()
                                              .disconnect(flutterV2ray)
                                      : context
                                          .read<AuthorizationController>()
                                          .getConnectionJson(
                                              _tokenController.text)
                                  : null,
                              child: BlocBuilder<ConnectionController,
                                  ConnectingStates>(
                                builder: (context, state) {
                                  return Container(
                                      child: Image.asset(
                                          state is ConnectionStateConnected
                                              ? connectedGlobe
                                              : state is ConnectionStateLoading
                                                  ? connectingGlobe
                                                  : disconnectedGlobe));
                                },
                              )),
                        ],
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: SnappingSheet(
                      lockOverflowDrag: true,
                      controller: _snappingSheetControllerAbove,
                      onSnapCompleted: (sheetPosition, snappingPosition) {
                        setState(() => isAboveSheetOpen =
                            snappingPosition.grabbingContentOffset == 1.0
                                ? false
                                : true);
                      },
                      snappingPositions: [
                        SnappingPosition.factor(
                          grabbingContentOffset: GrabbingContentOffset.top,
                          positionFactor: 0.3,
                        ),
                        SnappingPosition.factor(
                          snappingCurve: Curves.elasticOut,
                          snappingDuration: Duration(milliseconds: 1750),
                          positionFactor: 0.15,
                        ),
                      ],
                      child: Container(),
                      grabbingHeight: 50,
                      grabbing: DefaultGrabbing(
                        reverse: true,
                        color: blackColor,
                      ),
                      sheetAbove: SnappingSheetContent(
                        draggable: true,
                        child: buttonRow(context, state),
                      ),
                    ),
                  ),
                  Container(
                    child: SnappingSheet(
                      lockOverflowDrag: true,
                      snappingPositions: [
                        SnappingPosition.factor(
                          positionFactor: 0.05,
                          snappingCurve: Curves.easeOutExpo,
                          snappingDuration: Duration(seconds: 1),
                          grabbingContentOffset: GrabbingContentOffset.top,
                        ),
                        SnappingPosition.factor(
                          snappingCurve: Curves.elasticOut,
                          snappingDuration: Duration(milliseconds: 1750),
                          positionFactor: 0.2,
                        ),
                      ],
                      child: Container(),
                      grabbingHeight: 50,
                      grabbing: DefaultGrabbing(
                        color: baseViewColor,
                        isAboveSnappingSheet: false,
                      ),
                      sheetBelow: SnappingSheetContent(
                        draggable: true,
                        child: BottomUpSnappingSheet(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      child: TopDownSnappingSheet(
                        controller: _snappingSheetControllerAbove,
                        tokenController: _tokenController,
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
