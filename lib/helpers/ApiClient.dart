
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_vpn/models/token_model.dart';
import 'ApiEndpoints.dart';
import 'package:retrofit/retrofit.dart';
part 'ApiClient.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(ApiEndpoints.xray)
  Future<String> getConnectionJson(@Body() TokenModel tokenModel);

}
