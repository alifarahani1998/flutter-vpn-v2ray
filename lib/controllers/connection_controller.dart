import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';

abstract class ConnectingStates {}

class ConnectionStateInitial extends ConnectingStates {}

class ConnectionStateLoading extends ConnectingStates {}

class ConnectionStateConnected extends ConnectingStates {}

class ConnectionStateError extends ConnectingStates {
  final String error;
  ConnectionStateError({required this.error});
}

class ConnectionController extends Cubit<ConnectingStates> {
  ConnectionController() : super(ConnectionStateInitial());

  Future<void> connect(
      dynamic connectionJson, FlutterV2ray flutterV2ray) async {
    emit(ConnectionStateLoading());
    await Future.delayed(Duration(seconds: 1));
    if (await flutterV2ray.requestPermission()) {
      await flutterV2ray.startV2Ray(
        remark: "Default Remark",
        config: json.encode(connectionJson),
        proxyOnly: false,
      );
      emit(ConnectionStateConnected());
    }
    // else {
    //   if (context.mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Permission Denied'),
    //       ),
    //     );
    //   }
    // }
  }

  Future<void> disconnect(FlutterV2ray flutterV2ray) async {
    emit(ConnectionStateLoading());
    await flutterV2ray.stopV2Ray();
    emit(ConnectionStateInitial());
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
