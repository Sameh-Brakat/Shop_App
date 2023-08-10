import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/shared/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModeldata;

  void UserLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());

    DioHelper.postData(url: LOGIN, data: {
      'email': email,
      'password': password,
    }).then((value) {
      // print(value!.data);
      // print(value!.data.runtimeType);
      // print(value!.runtimeType);
      // var jsonMap = json.decode(value.data);
      // print(jsonMap);
      // print(jsonMap.runtimeType);

      loginModeldata = LoginModel.fromJson(value?.data);

      emit(LoginSuccessState(loginModeldata!));
    }).catchError((error) {
      print(error);
      emit(LoginErrorState(error.toString()));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;

  bool isPass = true;

  void changePassVis() {
    isPass = !isPass;
    suffixIcon =
        isPass ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginChangeIconPassState());
  }
}
