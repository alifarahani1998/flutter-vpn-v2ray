import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:moodiboom/controllers/authorization_controller.dart';
import 'package:moodiboom/controllers/connection_controller.dart';
import 'package:moodiboom/controllers/counter_controller.dart';
import 'package:moodiboom/controllers/details_info_controller.dart';
import 'package:moodiboom/helpers/extensions.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:moodiboom/widgets/bottom_up_snapping_sheet.dart';
import 'package:moodiboom/widgets/default_grabbing.dart';
import 'package:moodiboom/widgets/dialogs.dart';
import 'package:moodiboom/widgets/main_button.dart';
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
      new SnappingSheetController();
  final SnappingSheetController _snappingSheetControllerBelow =
      new SnappingSheetController();
  late bool isAboveSheetOpen;
  late bool isBelowSheetOpen;
  late bool connectedFromGlobe;
  late Timer _aboveTimer;
  late Timer _belowTimer;

  @override
  void initState() {
    super.initState();
    _tokenController.text = Global.shPreferences.containsKey(TOKEN)
        ? Global.shPreferences.getString(TOKEN)!
        : '';
    isAboveSheetOpen = false;
    isBelowSheetOpen = false;
    connectedFromGlobe = false;
    flutterV2ray = FlutterV2ray(onStatusChanged: (status) => v2rayStatus.value = status);
    flutterV2ray.initializeV2Ray();
    isVpnActive();
  }


  Future<void> isVpnActive() async {
    bool isVpnActive;
    List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, type: InternetAddressType.any);
    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) =>
            interface.name.contains("tun") ||
            interface.name.contains("ppp") ||
            interface.name.contains("pptp"))
        : isVpnActive = false;

    if (isVpnActive)
      context.read<ConnectionController>().emit(ConnectionStateConnected());
  }

  void resetConfig() async {
    await Global.shPreferences.clear();
    context.read<ConnectionController>().disconnect(flutterV2ray);
    context.read<AuthorizationController>().emit(AuthorizationStatesInitial());
    context.read<DetailsInfoController>().emit(DetailsInfoStateInitial());
    _tokenController.clear();
    setState(() {});
  }

  void autoScrollSnappingSheetAbove() async {
    int counter = 5;
    _aboveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter == 0) {
        if (isAboveSheetOpen)
          _snappingSheetControllerAbove.snapToPosition(
            SnappingPosition.factor(
              grabbingContentOffset: GrabbingContentOffset.top,
              positionFactor: 0.3,
            ),
          );
        timer.cancel();
      } else
        counter--;
    });
  }

  void autoScrollSnappingSheetBelow() async {
    int counter = 5;
    _belowTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter == 0) {
        if (isBelowSheetOpen)
          _snappingSheetControllerBelow.snapToPosition(SnappingPosition.factor(
            positionFactor: 0.05,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: const Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.top,
          ));
        timer.cancel();
      } else
        counter--;
    });
  }

  Widget buttonRow(BuildContext context, AuthorizationStates state) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      color: blackColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MainButton(
              text: state is AuthorizationStatesAuthorized
                  ? 'Delete'
                  : 'Register',
              onPressed: () => state is AuthorizationStatesAuthorized
                  ? showDialog(
                          context: context,
                          builder: (context) => warningDialog(
                              context,
                              'Are you sure\nyou want to delete your token?',
                              'Delete',
                              'Cancel'))
                      .then((value) => value ? resetConfig() : null)
                  : _tokenController.text.canConfirmToken()
                      ? context
                          .read<AuthorizationController>()
                          .getConnectionConfig(_tokenController.text)
                      : null,
              isWaiting: state is AuthorizationStatesLoading,
              color: state is AuthorizationStatesAuthorized
                  ? errorColor
                  : whiteColor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: MainButton(
              onPressed: () async => await launchUrl(Uri.parse(telegramURL)),
              text: state is AuthorizationStatesAuthorized
                  ? 'Renewal'
                  : 'Buy a token',
              color: baseColor,
              isWaiting: state is AuthorizationStatesLoading,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorizationController, AuthorizationStates>(
      listener: (context, state) async {
        if (state is AuthorizationStatesAuthorized) {
          _tokenController.text = Global.shPreferences.getString(TOKEN)!;
          context
              .read<ConnectionController>()
              .requestVPNPermission(flutterV2ray);
          if (connectedFromGlobe) {
            await Future.delayed(const Duration(seconds: 2));
            context
                .read<ConnectionController>()
                .connect(Global.connectionJsonModel, flutterV2ray);
            connectedFromGlobe = false;
          }
        }
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
                                          : state is AuthorizationStatesLoading
                                              ? 'Registering...'
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
                                          : state is AuthorizationStatesInitial ||
                                                  state
                                                      is AuthorizationStatesLoading
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
                          BlocConsumer<ConnectionController, ConnectingStates>(
                            listener: (context, state) {
                              if (state is ConnectionStateConnected) {
                                context
                                    .read<DetailsInfoController>()
                                    .getConnectionDetails();
                                _snappingSheetControllerBelow.snapToPosition(
                                  SnappingPosition.factor(
                                    snappingCurve: Curves.elasticOut,
                                    snappingDuration:
                                        const Duration(milliseconds: 200),
                                    positionFactor: 0.2,
                                  ),
                                );
                                context
                                    .read<CounterController>()
                                    .startSecondTimer();
                                context
                                    .read<CounterController>()
                                    .startMinuteTimer();
                                context
                                    .read<CounterController>()
                                    .startHourTimer();
                              } else if (state is ConnectionStateInitial)
                                context
                                    .read<CounterController>()
                                    .stopAllTimers();
                            },
                            builder: (context, state) => state
                                    is ConnectionStateConnected
                                ? BlocBuilder<CounterController, CounterStates>(
                                    builder: (context, state) {
                                      return state is CounterStateCounting
                                          ? Text(
                                              context
                                                      .read<CounterController>()
                                                      .hour +
                                                  ' : ' +
                                                  context
                                                      .read<CounterController>()
                                                      .minute +
                                                  ' : ' +
                                                  context
                                                      .read<CounterController>()
                                                      .second,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          : Container();
                                    },
                                  )
                                : Container(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                            child: InkWell(onTap: () {
                              if (_tokenController.text.canConfirmToken()) {
                                if (state is AuthorizationStatesAuthorized) {
                                  context.read<ConnectionController>().state
                                          is ConnectionStateInitial
                                      ? context
                                          .read<ConnectionController>()
                                          .connect(Global.connectionJsonModel,
                                              flutterV2ray)
                                      : context
                                          .read<ConnectionController>()
                                          .disconnect(flutterV2ray);
                                } else {
                                  connectedFromGlobe = true;
                                  context
                                      .read<AuthorizationController>()
                                      .getConnectionConfig(
                                          _tokenController.text);
                                }
                              }
                            }, child: BlocBuilder<ConnectionController,
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
                          ),
                          BlocBuilder<ConnectionController, ConnectingStates>(
                            builder: (context, state) =>
                                state is ConnectionStateConnected
                                    ? TextButton(
                                        onPressed: () => context
                                            .read<ConnectionController>()
                                            .disconnect(flutterV2ray),
                                        child: Text(
                                          'Disconnect',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: errorColor),
                                        ))
                                    : Container(),
                          )
                        ],
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height < 685.0
                        ? MediaQuery.of(context).size.height / 2.8
                        : MediaQuery.of(context).size.height < 785.0
                            ? MediaQuery.of(context).size.height / 3
                            : MediaQuery.of(context).size.height / 3.1,
                    child: SnappingSheet(
                      lockOverflowDrag: true,
                      controller: _snappingSheetControllerAbove,
                      onSnapCompleted: (sheetPosition, snappingPosition) {
                        if (snappingPosition.grabbingContentOffset == 1.0) {
                          setState(() {
                            isAboveSheetOpen = false;
                          });
                          _aboveTimer.cancel();
                        } else {
                          setState(() {
                            isAboveSheetOpen = true;
                            autoScrollSnappingSheetAbove();
                          });
                        }
                      },
                      snappingPositions: [
                        SnappingPosition.factor(
                          grabbingContentOffset: GrabbingContentOffset.top,
                          positionFactor: 0.3,
                        ),
                        SnappingPosition.factor(
                          snappingCurve: Curves.elasticOut,
                          snappingDuration: const Duration(milliseconds: 200),
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
                        controller: _snappingSheetControllerBelow,
                        snappingPositions: [
                          SnappingPosition.factor(
                            positionFactor: 0.05,
                            snappingCurve: Curves.easeOutExpo,
                            snappingDuration: const Duration(seconds: 1),
                            grabbingContentOffset: GrabbingContentOffset.top,
                          ),
                          SnappingPosition.factor(
                            snappingCurve: Curves.elasticOut,
                            snappingDuration: const Duration(milliseconds: 200),
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
                        onSnapCompleted: (sheetPosition, snappingPosition) {
                          if (snappingPosition.grabbingContentOffset == 0.0) {
                            context
                                .read<DetailsInfoController>()
                                .getConnectionDetails();
                            isBelowSheetOpen = true;
                            autoScrollSnappingSheetBelow();
                          } else {
                            isBelowSheetOpen = false;
                            _belowTimer.cancel();
                          }
                        }),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      child: TopDownSnappingSheet(
                        controller: _snappingSheetControllerAbove,
                        tokenController: _tokenController,
                        isAboveSheetOpen: isAboveSheetOpen,
                        flutterV2ray: flutterV2ray,
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
