import 'dart:developer';

import 'package:api_with_flutter/core/api/api_consumer.dart';
import 'package:api_with_flutter/core/api/endpoint.dart';
import 'package:api_with_flutter/core/cache/cache_helper.dart';
import 'package:api_with_flutter/core/error/exceptions.dart';
import 'package:api_with_flutter/core/functions/upload_image_to_api.dart';
import 'package:api_with_flutter/cubit/user_state.dart';
import 'package:api_with_flutter/models/sign_up_model.dart';
import 'package:api_with_flutter/models/signin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.api) : super(UserInitial());

  final ApiConsumer api;
  //Sign in Form key
  GlobalKey<FormState> signInFormKey = GlobalKey();
  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  //Sign Up Form key
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  //Profile Pic
  XFile? profilePic;
  //Sign up name
  TextEditingController signUpName = TextEditingController();
  //Sign up phone number
  TextEditingController signUpPhoneNumber = TextEditingController();
  //Sign up email
  TextEditingController signUpEmail = TextEditingController();
  //Sign up password
  TextEditingController signUpPassword = TextEditingController();
  //Sign up confirm password
  TextEditingController confirmPassword = TextEditingController();
  SignInModel? user;
  signIn() async {
    try {
      emit(SignInLoading());
      final response = await api.post(
        EndPoint.signIn,
        data: {
          ApiKey.email: signInEmail.text,
          ApiKey.password: signInPassword.text,
        },
      );
      user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user!.token);
      MyCacheHelper().saveData(key: ApiKey.token, value: user!.token);
      MyCacheHelper().saveData(key: ApiKey.id, value: decodedToken[ApiKey.id]);
      emit(SignInSuccess());
    } on ServerException catch (e) {
      emit(SignInFailure(errMessage: e.errModel.errorMessage));
    }
  }

  upLoadProfilePic(XFile image) async {
    profilePic = image;
    emit(UploadProfilePic());
  }

  signUp() async {
    try {
      emit(SignUpLoading());
      final response = await api.post(EndPoint.signUp, isFormData: true, data: {
        ApiKey.name: signUpName.text,
        ApiKey.phone: signUpPhoneNumber.text,
        ApiKey.email: signUpEmail.text,
        ApiKey.password: signUpPassword.text,
        ApiKey.confirmPassword: confirmPassword.text,
        ApiKey.location:
            '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}',
        ApiKey.profilePic: await uploadImageToApi(profilePic!),
      });
      final signUpModel = SignUpModel.fromJson(response);
      emit(SignUpSuccess(message: signUpModel.message));
    } on ServerException catch (e) {
      emit(SignInFailure(errMessage: e.errModel.errorMessage));
    }
  }
}
