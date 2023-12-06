import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vpn/helpers/global.dart';
import 'package:flutter_vpn/models/token_model.dart';

abstract class TokenStates {}

class TokenStateInitial extends TokenStates {}

class TokenStateLoading extends TokenStates {}

class TokenStateConnected extends TokenStates {}

class TokenStateError extends TokenStates {}

class TokenController extends Cubit<TokenStates> {
  TokenController() : super(TokenStateInitial());

  late String connectionJson;

  void getConnectionJson(TokenModel tokenModel) async {
    emit(TokenStateLoading());
    await Global.apiClient.getConnectionJson(tokenModel).then((value) async {
      print('this is connectionJson: $value');
      connectionJson = value;
      emit(TokenStateConnected());
    }).catchError((Object obj) {
      final res = (obj as DioError).response;
      print("Got error : ${res!.statusCode} -> ${res.statusMessage}");
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          switch (res?.statusCode) {
            case 401:
              Global.isTokenValid = false;
              break;
            default:
              emit(TokenStateError());
              break;
          }
          break;
        default:
      }
    });
  }
}
