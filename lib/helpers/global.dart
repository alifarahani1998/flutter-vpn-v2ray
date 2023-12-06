import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_vpn/helpers/ApiClient.dart';
import 'package:flutter_vpn/helpers/ApiEndpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

//a typedef to use in class for callback functions
typedef OnValueCallback = void Function(int value);

abstract class Global {
  //To hold user current token globally
  //It's value will set in LoginPage
  static String token = "";

  static int smsTimer = 120;
  static int smsPasargadTimer = 120;
  static int smsChangeMobileTimer = 120;
  static int changeMailTimer = 600;
  static int deleteAccountTimer = 120;
  static bool isTokenValid = true;

  //API Client instance to use globally
  static ApiClient apiClient = new ApiClient(Dio(BaseOptions(
    contentType: ApiEndpoints.contentTypeJson,
    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
  )));

  //Logger Instance to use globally

  //ُ/SharedPreferences instance to use globally
  //This instance will initialize in SplashPage func
  static late SharedPreferences shPreferences;

  //TODO: remove this var and use Enums in page constructor and enums instead.
  //To hold what page called NumberPage
  static late String previousPage;
}
