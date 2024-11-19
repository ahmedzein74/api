import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/api_consumer.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/endpoint.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/cache/cache_helper.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/error/exceptions.dart';
import 'package:happy_tech_mastering_api_with_flutter/cubit/user_state.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/signin_model.dart';
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
  SigninModel? user;
  signIn() async {
    try {
      emit(SignInLoading());
      final response = await api.post(
        Endpoint.signIn,
        data: {
          ApiKeys.email: signInEmail.text,
          ApiKeys.password: signInPassword.text
        },
      );

      user = SigninModel.fromJson(response);

      final decodedToken = JwtDecoder.decode(user!.token);
      MyCacheHelper().saveData(
        key: ApiKeys.token,
        value: user!.token,
      );
      MyCacheHelper().saveData(
        key: ApiKeys.id,
        value: decodedToken[ApiKeys.id],
      );
      emit(SignInSuccess());
    } on ServerException catch (e) {
      emit(SignInError(e.errorModel.errorMessage));
    }
  }
}
