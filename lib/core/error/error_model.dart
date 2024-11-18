import 'package:happy_tech_mastering_api_with_flutter/core/api/endpoint.dart';

class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      status: json[ApiKeys.status],
      errorMessage: json[ApiKeys.errmessage],
    );
  }
}
