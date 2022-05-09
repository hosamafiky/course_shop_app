import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login_module/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

import '../../shared/cubit/register_cubit/register_cubit.dart';
import '../../shared/cubit/register_cubit/register_states.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                token = state.loginModel.data!.token!;
                navigateAndFinish(context, const ShopLayout());
              });
            } else {
              showToast(
                text: state.loginModel.message!,
                state: ToastState.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register to browse our amazing app.',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(height: 30.0),
                        CustomFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validateFunc: (value) {
                            if (value!.isEmpty) {
                              return 'Username is required!';
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
                              return 'Email Address is required!';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email,
                        ),
                        const SizedBox(height: 15.0),
                        CustomFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validateFunc: (value) {
                            if (value!.isEmpty) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock,
                          isSecure: cubit.isPassword,
                          suffix: cubit.suffixIcon,
                          onSuffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                        ),
                        const SizedBox(height: 15.0),
                        CustomFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validateFunc: (value) {
                            if (value!.isEmpty) {
                              return 'Phone Number is required!';
                            }
                            return null;
                          },
                          label: 'Phone Number',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(height: 30.0),
                        SizedBox(
                          width: double.infinity,
                          height: 60.0,
                          child: ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => CustomButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                },
                                text: 'register'),
                            fallback: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              child: const Text('LOGIN'),
                              onPressed: () {
                                navigateAndFinish(context, const LoginScreen());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
