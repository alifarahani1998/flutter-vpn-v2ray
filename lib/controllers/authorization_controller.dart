import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/models/token_model.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthorizationStates {}

class AuthorizationStatesInitial extends AuthorizationStates {}

class AuthorizationStatesAuthorized extends AuthorizationStates {}

class AuthorizationStatesError extends AuthorizationStates {
  final String error;
  AuthorizationStatesError({required this.error});
}

class AuthorizationController extends Cubit<AuthorizationStates> {
  AuthorizationController() : super(AuthorizationStatesInitial()) {
    isAuthorized();
  }

  Future isAuthorized() async {
    Global.shPreferences = await SharedPreferences.getInstance();
    if (Global.shPreferences.containsKey(TOKEN))
      await getConnectionJson(Global.shPreferences.getString(TOKEN)!);
    else
      emit(AuthorizationStatesInitial());
  }

  Future<void> getConnectionJson(String token) async {
      
    await Global.apiClient
        .getConnectionJson(TokenModel(token: token))
        .then((value) async {
      emit(AuthorizationStatesAuthorized());
      await Global.shPreferences.setString(TOKEN, token);
      Global.connectionJsonModel = value;
    }).catchError((Object obj) {
      final res = (obj as DioError).response;
      print("Got error : ${res!.statusCode} -> ${res.statusMessage}");
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          switch (res?.statusCode) {
            case 500:
              emit(AuthorizationStatesError(error: 'Token is invalid!'));
              break;
            default:
              break;
          }
          break;
        default:
      }
    });
  }
}
