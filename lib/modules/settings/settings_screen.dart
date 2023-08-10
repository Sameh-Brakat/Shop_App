import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../../layout/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.get(context).profileModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 8,
                        width: double.infinity,
                      ),
                      Positioned(
                        child: Align(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                                'https://student.valuxapps.com/storage/assets/defaults/user.jpg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ConditionalBuilder(
                  condition: state is AppLoadingUpdateDataState,
                  builder: (context) => LinearProgressIndicator(),
                  fallback: (context) => Container(),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      DefaultForm(
                        controller: nameController,
                        type: TextInputType.name,
                        label: '',
                        preIcon: Icons.person,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Name Must not be Empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DefaultForm(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: '',
                        preIcon: Icons.email,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Email Must not be Empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DefaultForm(
                        controller: phoneController,
                        type: TextInputType.phone,
                        label: '',
                        preIcon: Icons.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Phone Must not be Empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                          text: 'Update',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AppCubit.get(context).updateData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                              );
                            }
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                          text: 'Sign Out',
                          onPressed: () {
                            SignOut(context);
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
