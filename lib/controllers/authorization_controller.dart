import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vpn/helpers/global.dart';
import 'package:flutter_vpn/models/token_model.dart';
import 'package:flutter_vpn/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthorizationStates {}

class AuthorizationStatesInitial extends AuthorizationStates {}

class AuthorizationStatesAuthorized extends AuthorizationStates {}

class AuthorizationStatesUnauthorized extends AuthorizationStates {}

class AuthorizationStatesUnauthorizedAndSignedOut extends AuthorizationStates {}

class AuthorizationController extends Cubit<AuthorizationStates> {
  AuthorizationController() : super(AuthorizationStatesInitial()) {
    isAuthorized();
  }

  Future isAuthorized() async {
    Global.shPreferences = await SharedPreferences.getInstance();
    if (Global.shPreferences.containsKey(TOKEN)) {
      await getConnectionJson();
      emit(AuthorizationStatesAuthorized());
    } else
      emit(AuthorizationStatesUnauthorized());
  }

  Future<void> getConnectionJson() async {
    await Global.apiClient
        .getConnectionJson(
            TokenModel(token: Global.shPreferences.getString(TOKEN)))
        .then((value) async {
      Global.connectionJsonModel = value;
    }).catchError((Object obj) {
      final res = (obj as DioError).response;
      print("Got error : ${res!.statusCode} -> ${res.statusMessage}");
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          switch (res?.statusCode) {
            default:
              break;
          }
          break;
        default:
      }
    });
  }
}
