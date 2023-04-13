import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cashe_helper.dart';

import '../../shared/components/constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var emailcontroller = TextEditingController();
  var passcontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          if (state.loginModel.status) {
            Toastt(
              message: state.loginModel.message!,
              state: ToastStates.SUCCESS,
            );

            CacheHelper.saveData(
              key: 'token',
              value: state.loginModel.data?.token,
            ).then((value) {
              token = state.loginModel.data?.token;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeLayout(),
                  ),
                  (route) => false);
            });
          } else {
            Toastt(
                message: state.loginModel.message!, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Text('Login',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 30,
                  ),
                  DefaultForm(
                    isPassword: false,
                    controller: emailcontroller,
                    type: TextInputType.emailAddress,
                    label: 'Email',
                    preIcon: Icons.email_outlined,
                    validate: ((value) {
                      if (value!.isEmpty) {
                        return 'Email Must not be Empty';
                      }
                      return null;
                    }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultForm(
                    suffix: LoginCubit.get(context).suffixIcon,
                    suffixPressed: () {
                      LoginCubit.get(context).changePassVis();
                    },
                    isPassword: LoginCubit.get(context).isPass,
                    submit: (value) {
                      if (formkey.currentState!.validate()) {
                        LoginCubit.get(context).UserLogin(
                            email: emailcontroller.text,
                            password: passcontroller.text);
                      }
                    },
                    controller: passcontroller,
                    type: TextInputType.visiblePassword,
                    label: 'Password',
                    preIcon: Icons.lock_outline,
                    validate: ((value) {
                      if (value!.isEmpty) {
                        return 'Password Must not be Empty';
                      }
                      return null;
                    }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ConditionalBuilder(
                      condition: state is! LoginLoadingState,
                      builder: (context) => DefaultButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                LoginCubit.get(context).UserLogin(
                                    email: emailcontroller.text,
                                    password: passcontroller.text);
                              }
                            },
                          ),
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator())),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an Account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ));
                          },
                          child: Text('Register Now !')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
