import 'package:dio/dio.dart' hide Headers;
import 'package:moodiboom/models/connection_model.dart';
import 'package:moodiboom/models/details_info_model.dart';
import 'package:moodiboom/models/token_model.dart';
import 'ApiEndpoints.dart';
import 'package:retrofit/retrofit.dart';
part 'ApiClient.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(ApiEndpoints.getConfig)
  Future<dynamic> getConnectionConfig(@Body() TokenModel tokenModel);

  @POST(ApiEndpoints.getDetails)
  Future<DetailsInfoModel> getConnectionDetails(@Body() TokenModel tokenModel);
}
