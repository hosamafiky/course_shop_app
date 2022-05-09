import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/login_module/login_screen.dart';
import 'package:shop_app/shared/cubit/home_cubit/home_cubit.dart';

import '../network/local/cache_helper.dart';

String? token = '';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imgPath,
  }) : super(key: key);
  final String title, subtitle, imgPath;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(imgPath),
          ),
        ),
        const SizedBox(height: 30.0),
        Text(
          title,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 15.0),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.controller,
    required this.type,
    required this.validateFunc,
    required this.label,
    required this.prefix,
    this.isSecure = false,
    this.onSuffixPressed,
    this.suffix,
    this.onSubmit,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType type;
  final String? Function(String?)? validateFunc, onSubmit;
  final Function? onSuffixPressed;
  final String label;
  final IconData prefix;
  final IconData? suffix;
  final bool isSecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validateFunc,
      obscureText: isSecure,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: () {
                  onSuffixPressed!();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text!.toUpperCase(),
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void navigateAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false,
  );
}

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  switch (state) {
    case ToastState.SUCCESS:
      return Colors.green;
    case ToastState.ERROR:
      return Colors.red;
    case ToastState.WARNING:
      return Colors.amber;
  }
}

void showToast({
  required String text,
  required ToastState state,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void signOut(context) {
  CacheHelper.removeData(key: 'isLogged').then((value) {
    token = '';
    navigateAndFinish(context, const LoginScreen());
  });
}

String capitalize(String string) {
  if (string.isEmpty) {
    return string;
  }
  return string[0].toUpperCase() + string.substring(1);
}

Widget buildListItem(product, context) => Container(
      height: 120.0,
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          SizedBox(
            width: 120.0,
            height: 120.0,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage(product.image!),
                  height: 120.0,
                  width: 120.0,
                ),
                if (product.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3.0, vertical: 1.0),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      product.price!.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    if (product.discount != 0)
                      Text(
                        product.oldPrice.toString(),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14.0,
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      icon: CircleAvatar(
                        radius: 12.0,
                        backgroundColor:
                            HomeCubit.get(context).favorites[product.id]!
                                ? Colors.deepOrange
                                : Colors.grey[200],
                        child: const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                      onPressed: () {
                        HomeCubit.get(context).changeFavoriteData(product.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
