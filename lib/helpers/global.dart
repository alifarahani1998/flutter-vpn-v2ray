import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_vpn/helpers/ApiClient.dart';
import 'package:flutter_vpn/helpers/ApiEndpoints.dart';
import 'package:flutter_vpn/models/connection_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//a typedef to use in class for callback functions
typedef OnValueCallback = void Function(int value);

abstract class Global {
  static String apiToken = '';
  static ConnectionJsonModel connectionJsonModel = new ConnectionJsonModel();

  static ApiClient apiClient = new ApiClient(Dio(BaseOptions(
    contentType: ApiEndpoints.contentTypeJson,
    headers: {HttpHeaders.authorizationHeader: "Bearer $apiToken"},
  )));

  static late SharedPreferences shPreferences;
}
