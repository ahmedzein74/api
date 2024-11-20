import 'package:api_with_flutter/core/api/endpoint.dart';
import 'package:api_with_flutter/core/cache/cache_helper.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiKey.token] =
        MyCacheHelper().getData(key: ApiKey.token) != null
            ? 'FOODAPI ${MyCacheHelper().getData(key: ApiKey.token)}'
            : null;
    super.onRequest(options, handler);
  }
}
