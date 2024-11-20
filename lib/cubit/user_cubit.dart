import 'dart:developer';
import 'dart:math';

import 'package:api_with_flutter/core/api/api_consumer.dart';
import 'package:api_with_flutter/core/api/endpoint.dart';
import 'package:api_with_flutter/core/cache/cache_helper.dart';
import 'package:api_with_flutter/core/error/exceptions.dart';
import 'package:api_with_flutter/core/functions/upload_image_to_api.dart';
import 'package:api_with_flutter/cubit/user_state.dart';
import 'package:api_with_flutter/models/sign_up_model.dart';
import 'package:api_with_flutter/models/signin_model.dart';
import 'package:api_with_flutter/models/user_model.dart';
import 'package:api_with_flutter/repos/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepo) : super(UserInitial());

  final UserRepo userRepo;
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
    final response = await userRepo.signIn(
        email: signInEmail.text, password: signInPassword.text);

    response.fold((failure) {
      emit(SignInFailure(errMessage: failure));
    }, (signModel) {
      emit(SignInSuccess());
    });
  }

  upLoadProfilePic(XFile image) async {
    profilePic = image;
    emit(UploadProfilePic());
  }

  signUp() async {
    emit(SignUpLoading());
    final response = await userRepo.signUp(
        name: signUpName.text,
        phone: signUpPhoneNumber.text,
        email: signUpEmail.text,
        password: signUpPassword.text,
        confirmPassword: confirmPassword.text,
        profilePic: profilePic!);
    response.fold((failure) {
      emit(SignUpFailure(errMessage: failure));
    }, (signUpModel) {
      emit(SignUpSuccess(message: signUpModel.message));
    });
  }

  getUserProfile() async {
    final response = await userRepo.getUserProfile();
    response.fold((failure) {
      emit(GetUserFailure(errMessage: failure));
    }, (userModel) {
      emit(GetUserSuccess(userModel: userModel));
    });
  }
}
