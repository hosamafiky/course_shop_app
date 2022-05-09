import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login_module/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/bloc_observer.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/style/style.dart';

import 'modules/onboarding_module.dart';
import 'shared/network/local/cache_helper.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await CacheHelper.init();
      bool? isBoardOff = CacheHelper.getData(key: 'offBoard') ?? false;
      token = CacheHelper.getData(key: 'token');
      // ignore: avoid_print
      print('token is : $token');
      DioHelper.init();
      runApp(
        MyApp(
          isBoardOff: isBoardOff!,
          token: token,
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.isBoardOff, this.token}) : super(key: key);
  final bool? isBoardOff;
  final String? token;

  Widget chooseWidget(bool? offBoard, String? token) {
    if (offBoard!) {
      if (token != null) {
        return const ShopLayout();
      } else {
        return const LoginScreen();
      }
    } else {
      return const OnBoardingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: chooseWidget(isBoardOff, token),
    );
  }
}
