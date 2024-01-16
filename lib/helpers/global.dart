import 'dart:io';
import 'package:dio/dio.dart';
import 'package:moodiboom/helpers/ApiClient.dart';
import 'package:moodiboom/helpers/ApiEndpoints.dart';
// import 'package:moodiboom/models/connection_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

//a typedef to use in class for callback functions
typedef OnValueCallback = void Function(int value);

abstract class Global {
  static String apiToken = '';
  static dynamic connectionJsonModel = '';

  static ApiClient apiClient = new ApiClient(Dio(BaseOptions(
    contentType: ApiEndpoints.contentTypeJson,
    headers: {HttpHeaders.authorizationHeader: "Bearer $apiToken"},
  )));

  static late SharedPreferences shPreferences;
  static final Logger logger = new Logger();
}
