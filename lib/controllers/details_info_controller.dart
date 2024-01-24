import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodiboom/helpers/global.dart';
import 'package:moodiboom/models/token_model.dart';
import 'package:moodiboom/utils/constants.dart';

abstract class DetailsInfoStates {}

class DetailsInfoStateInitial extends DetailsInfoStates {}

class DetailsInfoStateLoading extends DetailsInfoStates {}

class DetailsInfoStateLoaded extends DetailsInfoStates {
  final int? daysLeft;
  final double? trafficLeft;

  DetailsInfoStateLoaded({required this.daysLeft, required this.trafficLeft});
}

class DetailsInfoStateError extends DetailsInfoStates {}

class DetailsInfoController extends Cubit<DetailsInfoStates> {
  DetailsInfoController() : super(DetailsInfoStateInitial()) {
    getConnectionDetails();
  }

  Future<void> getConnectionDetails() async {
    if (!Global.shPreferences.containsKey(TOKEN)) return;
    await Global.apiClient
        .getConnectionDetails(
            TokenModel(token: Global.shPreferences.getString(TOKEN)))
        .then((value) async {
      emit(DetailsInfoStateLoaded(
          daysLeft: value.daysLeft,
          trafficLeft: byteToGigaByte(value.trafficLeft!)));
    }).catchError((Object obj) {
      final res = (obj as DioError).response;
      print("Got error : ${res!.statusCode} -> ${res.statusMessage}");
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          switch (res?.statusCode) {
            default:
              emit(DetailsInfoStateError());
              break;
          }
          break;
        default:
      }
    });
  }

  double byteToGigaByte(int value) => value / (1024 * 1024 * 1024);
}
