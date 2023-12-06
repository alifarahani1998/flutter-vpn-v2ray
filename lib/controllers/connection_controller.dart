import 'package:flutter_bloc/flutter_bloc.dart';
abstract class ConnectingStates {}

class ConnectionStateInitial extends ConnectingStates {}

class ConnectionStateLoading extends ConnectingStates {}

class ConnectionStateConnected extends ConnectingStates {}

class ConnectionStateError extends ConnectingStates {}

class ConnectionController extends Cubit<ConnectingStates> {
  ConnectionController() : super(ConnectionStateInitial());


}
