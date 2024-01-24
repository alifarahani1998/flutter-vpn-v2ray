import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CounterStates {}

class CounterStateInitial extends CounterStates {}

class CounterStateCounting extends CounterStates {}

class CounterController extends Cubit<CounterStates> {
  CounterController() : super(CounterStateInitial());

  String second = '00';
  String minute = '00';
  String hour = '00';

  Timer? secTimer;
  Timer? minTimer;
  Timer? hrTimer;

  void startSecondTimer() {
    int sec = 0;
    secTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      sec++;
      if (sec > 59) {
        sec = 0;
        second = '00';
      } else if (sec < 10)
        second = '0' + sec.toString();
      else
        second = sec.toString();
      emit(CounterStateCounting());
    });
  }

  void startMinuteTimer() {
    int min = 0;
    minTimer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      min++;
      if (min > 59) {
        min = 0;
        minute = '00';
      } else if (min < 10)
        minute = '0' + min.toString();
      else
        minute = min.toString();
      emit(CounterStateCounting());
    });
  }

  void startHourTimer() {
    int hr = 0;
    hrTimer = Timer.periodic(const Duration(hours: 1), (Timer timer) {
      hr++;
      if (hr < 10)
        hour = '0' + hr.toString();
      else
        hour = hr.toString();
      emit(CounterStateCounting());
    });
  }

  void stopAllTimers() {
    secTimer!.cancel();
    minTimer!.cancel();
    hrTimer!.cancel();
    second = '00';
    minute = '00';
    hour = '00';
    emit(CounterStateInitial());
  }
}
