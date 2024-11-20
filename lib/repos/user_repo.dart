import 'package:api_with_flutter/core/api/api_consumer.dart';
import 'package:api_with_flutter/core/api/endpoint.dart';
import 'package:api_with_flutter/core/cache/cache_helper.dart';
import 'package:api_with_flutter/core/error/exceptions.dart';
import 'package:api_with_flutter/core/functions/upload_image_to_api.dart';
import 'package:api_with_flutter/models/sign_up_model.dart';
import 'package:api_with_flutter/models/signin_model.dart';
import 'package:api_with_flutter/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserRepo {
  final ApiConsumer api;

  UserRepo({required this.api});

  Future<Either<String, SignInModel>> signIn(
      {required String email, required String password}) async {
    try {
      final response = await api.post(
        EndPoint.signIn,
        data: {
          ApiKey.email: email,
          ApiKey.password: password,
        },
      );
      final user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user.token);
      MyCacheHelper().saveData(key: ApiKey.token, value: user.token);
      MyCacheHelper().saveData(key: ApiKey.id, value: decodedToken[ApiKey.id]);
      return right(user);
    } on ServerException catch (e) {
      return left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, SignUpModel>> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required XFile profilePic,
  }) async {
    try {
      final response = await api.post(EndPoint.signUp, isFormData: true, data: {
        ApiKey.name: name,
        ApiKey.phone: phone,
        ApiKey.email: email,
        ApiKey.password: password,
        ApiKey.confirmPassword: confirmPassword,
        ApiKey.location:
            '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}',
        ApiKey.profilePic: await uploadImageToApi(profilePic),
      });

      return right(SignUpModel.fromJson(response));
    } on ServerException catch (e) {
      return left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, UserModel>> getUserProfile() async {
    try {
      final response = await api.get(
        EndPoint.getUserDataEndPoint(
          MyCacheHelper().getData(key: ApiKey.id),
        ),
      );

      return right(UserModel.fromJson(response));
    } on ServerException catch (e) {
      return left(e.errModel.errorMessage);
    }
  }
}
