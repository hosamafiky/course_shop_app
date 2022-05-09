import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories_module/categories_screen.dart';
import 'package:shop_app/modules/favorites_module/favorites_screen.dart';
import 'package:shop_app/modules/products_module/products_screen.dart';
import 'package:shop_app/modules/settings_module/settings_screen.dart';
import 'package:shop_app/shared/cubit/end_points.dart';
import 'package:shop_app/shared/cubit/home_cubit/home_states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../models/categories_model.dart';
import '../../../models/favorite_model.dart';
import '../../components/components.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> botNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: 'Categories',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];
  List<Widget> screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBotNavBarIndex(index) {
    currentIndex = index;
    emit(HomeChangeBotNavBarIndexState());
  }

  Map<int, bool> favorites = {};
  HomeModel? homeModel;
  void getHomeData() {
    emit(HomeLoadingDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      }
      print(favorites.toString());
      emit(HomeSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorDataState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    emit(HomeLoadingCategoriesDataState());
    DioHelper.getData(url: GET_CATEGORIES).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(HomeSuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorCategoriesDataState());
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;
  void changeFavoriteData(int? productId) {
    emit(HomeLoadingChangeFavoritesDataState());
    favorites[productId!] = !favorites[productId]!;
    emit(HomeChangeFavoritesDataState());
    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);
      if (!changeFavoriteModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(HomeSuccessChangeFavoritesDataState(changeFavoriteModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      print(error.toString());
      emit(HomeErrorChangeFavoritesDataState());
    });
  }

  FavoriteModel? favoriteModel;
  void getFavoritesData() {
    emit(HomeLoadingGetFavoritesDataState());
    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);
      emit(HomeSuccessGetFavoritesDataState());
    }).catchError((error) {
      print('error in getting favorites data : ${error.toString()}');
      emit(HomeErrorGetFavoritesDataState());
    });
  }

  LoginModel? loginModel;
  void getUserData() {
    emit(HomeLoadingGetUserDataState());
    DioHelper.getData(
      url: GET_USERDATA,
      token: token,
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(HomeSuccessGetUserDataState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorGetUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(HomeLoadingUpdateUserDataState());
    DioHelper.putData(
      url: UPDATE_USERDATA,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
      token: token,
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(HomeSuccessUpdateUserDataState(loginModel!));

      getUserData();
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorUpdateUserDataState());
    });
  }
}
