import 'package:api_with_flutter/core/api/dio_consumer.dart';
import 'package:api_with_flutter/repos/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

void setupGetIt() {
  getit.registerSingleton<DioConsumer>(DioConsumer(Dio()));
  getit.registerSingleton<UserRepo>(UserRepo(
    api: getit.get<DioConsumer>(),
  ));
}
