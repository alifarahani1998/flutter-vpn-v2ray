import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/models/token_model.dart';
import 'package:moodiboom/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthorizationStates {}

class AuthorizationStatesInitial extends AuthorizationStates {} // unauthorized

class AuthorizationStatesAuthorized extends AuthorizationStates {}

class AuthorizationStatesLoading extends AuthorizationStates {}

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
      await getConnectionConfig(Global.shPreferences.getString(TOKEN)!);
    else
      emit(AuthorizationStatesInitial());
  }

  Future<void> getConnectionConfig(String token) async {
    emit(AuthorizationStatesLoading());
    await Global.apiClient
        .getConnectionConfig(TokenModel(token: token))
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
            default:
              emit(AuthorizationStatesError(error: 'Token is not valid!'));
              break;
          }
          break;
        default:
      }
    });
  }
}
