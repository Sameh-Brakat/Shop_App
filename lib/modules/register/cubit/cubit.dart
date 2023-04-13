import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../models/register_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterModel? registerModel;

  void userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(RegisterLoadingState());

    DioHelper.postData(url: REGISTER, data: {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    }).then((value) {
      registerModel = RegisterModel.fromJson(value?.data);

      emit(RegisterSuccessState(registerModel!));
    }).catchError((error) {
      print(error);
      emit(RegisterErrorState(error.toString()));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;

  bool isPass = true;

  void changePassVis() {
    isPass = !isPass;
    suffixIcon =
        isPass ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangeIconPassState());
  }
}
