import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/home_cubit/home_cubit.dart';

import '../../shared/cubit/home_cubit/home_states.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        if (state is HomeSuccessGetUserDataState) {
          if (cubit.loginModel!.status!) {
            var model = cubit.loginModel!;
            nameController.text = model.data!.name!;
            emailController.text = model.data!.email!;
            phoneController.text = model.data!.phone!;
          } else {
            showToast(
              text: cubit.loginModel!.message!,
              state: ToastState.ERROR,
            );
          }
        }
        return ConditionalBuilder(
          condition: state is! HomeSuccessGetUserDataState,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is HomeLoadingUpdateUserDataState)
                      Container(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: const LinearProgressIndicator(),
                      ),
                    CustomFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Username shouldn't be empty";
                        }
                        return null;
                      },
                      label: 'Username',
                      prefix: Icons.person_pin,
                    ),
                    const SizedBox(height: 15.0),
                    CustomFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Email Address shouldn't be empty";
                        }
                        return null;
                      },
                      label: 'Email Address',
                      prefix: Icons.email,
                    ),
                    const SizedBox(height: 15.0),
                    CustomFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return "Phone Number shouldn't be empty";
                        }
                        return null;
                      },
                      label: 'Phone Number',
                      prefix: Icons.phone,
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          cubit.updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                      text: 'update',
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      onPressed: () => signOut(context),
                      text: 'log out',
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
