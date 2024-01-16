part of 'ApiClient.dart';

class _ApiClient implements ApiClient {
  final Dio _dio;
  String? baseUrl;

  _ApiClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.moodiboom.net/';
  }

  @override
  Future<dynamic> getConnectionJson(tokenModel) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(tokenModel.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ConnectionJsonModel>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, 'customers/config/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    // var value = ConnectionJsonModel.fromJson(_result.data!);
    return _result.data;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
