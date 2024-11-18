import 'package:dio/dio.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/api_consumer.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/api_interceptors.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/endpoint.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/error/exceptions.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    dio.options.baseUrl = Endpoint.baseUrl;
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
  @override
  Future delete(String path,
      {Map<String, String>? queryParameters,
      Object? data,
      bool isFormData = false}) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: queryParameters,
        data:
            isFormData ? FormData.fromMap(data as Map<String, dynamic>) : data,
      );
      return response.data;
    } on DioException catch (e) {
      hnadleDioExceptions(e);
    }
  }

  @override
  Future get(String path,
      {Map<String, String>? queryParameters, Object? data}) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      hnadleDioExceptions(e);
    }
  }

  @override
  Future patch(String path,
      {Map<String, String>? queryParameters,
      Object? data,
      bool isFormData = false}) async {
    try {
      final response = await dio.patch(
        path,
        queryParameters: queryParameters,
        data:
            isFormData ? FormData.fromMap(data as Map<String, dynamic>) : data,
      );
      return response.data;
    } on DioException catch (e) {
      hnadleDioExceptions(e);
    }
  }

  @override
  Future post(String path,
      {Map<String, String>? queryParameters,
      Object? data,
      bool isFormData = false}) async {
    try {
      final response = await dio.post(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      hnadleDioExceptions(e);
    }
  }
}
