import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vpn/helpers/global.dart';
import 'package:flutter_vpn/models/token_model.dart';
import 'package:flutter_vpn/utils/constants.dart';

abstract class TokenStates {}

class TokenStateInitial extends TokenStates {}

class TokenStateLoading extends TokenStates {}

class TokenStateConnected extends TokenStates {}

class TokenStateError extends TokenStates {}

class TokenController extends Cubit<TokenStates> {
  TokenController() : super(TokenStateInitial());

  Future<void> getConnectionJson(String token) async {
    
    emit(TokenStateLoading());
    await Global.apiClient
        .getConnectionJson(TokenModel(token: token))
        .then((value) async {
      Global.connectionJsonModel = value;
      Global.shPreferences.setString(TOKEN, token);
      emit(TokenStateConnected());
    }).catchError((Object obj) {
      emit(TokenStateError());
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
