import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/utils/constants.dart';

abstract class ConnectingStates {}

class ConnectionStateInitial extends ConnectingStates {}

class ConnectionStateLoading extends ConnectingStates {}

class ConnectionStateConnected extends ConnectingStates {}

class ConnectionStateError extends ConnectingStates {
  final String error;
  ConnectionStateError({required this.error});
}

class ConnectionController extends Cubit<ConnectingStates> {
  ConnectionController() : super(ConnectionStateInitial()) {
    checkLastConnectionState();
  }

  void checkLastConnectionState() {
    if (Global.shPreferences.containsKey(IS_CONNECTED) &&
        Global.shPreferences.getBool(IS_CONNECTED)!)
      emit(ConnectionStateConnected());
  }

  Future<void> connect(dynamic connectionJson, FlutterV2ray flutterV2ray) async {
    emit(ConnectionStateLoading());
    await Future.delayed(Duration(seconds: 1));
    if (await flutterV2ray.requestPermission()) {
      await flutterV2ray.startV2Ray(
        remark: "Default Remark",
        config: json.encode(connectionJson),
        proxyOnly: false,
      );
      emit(ConnectionStateConnected());
      Global.shPreferences.setBool(IS_CONNECTED, true);
    }
  }

  Future<void> disconnect(FlutterV2ray flutterV2ray) async {
    await flutterV2ray.stopV2Ray();
    emit(ConnectionStateInitial());
    Global.shPreferences.setBool(IS_CONNECTED, false);
  }

  // void delay(String connectionJson) async {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         '${(await flutterV2ray.getServerDelay(config: connectionJson))}ms',
  //       ),
  //     ),
  //   );
  // }
}
