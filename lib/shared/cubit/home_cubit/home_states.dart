import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/login_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeChangeBotNavBarIndexState extends HomeStates {}

class HomeLoadingDataState extends HomeStates {}

class HomeSuccessDataState extends HomeStates {}

class HomeErrorDataState extends HomeStates {}

class HomeLoadingCategoriesDataState extends HomeStates {}

class HomeSuccessCategoriesDataState extends HomeStates {}

class HomeErrorCategoriesDataState extends HomeStates {}

class HomeLoadingChangeFavoritesDataState extends HomeStates {}

class HomeSuccessChangeFavoritesDataState extends HomeStates {
  final ChangeFavoriteModel changeFavoriteModel;

  HomeSuccessChangeFavoritesDataState(this.changeFavoriteModel);
}

class HomeChangeFavoritesDataState extends HomeStates {}

class HomeErrorChangeFavoritesDataState extends HomeStates {}

class HomeLoadingGetFavoritesDataState extends HomeStates {}

class HomeSuccessGetFavoritesDataState extends HomeStates {}

class HomeErrorGetFavoritesDataState extends HomeStates {}

class HomeLoadingGetUserDataState extends HomeStates {}

class HomeSuccessGetUserDataState extends HomeStates {
  final LoginModel? loginModel;

  HomeSuccessGetUserDataState(this.loginModel);
}

class HomeErrorGetUserDataState extends HomeStates {}

class HomeLoadingUpdateUserDataState extends HomeStates {}

class HomeSuccessUpdateUserDataState extends HomeStates {
  final LoginModel loginModel;

  HomeSuccessUpdateUserDataState(this.loginModel);
}

class HomeErrorUpdateUserDataState extends HomeStates {}
