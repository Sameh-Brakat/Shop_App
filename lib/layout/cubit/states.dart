import 'package:shop_app/models/fav_model.dart';
import 'package:shop_app/models/login_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavState extends AppStates {}

class AppLoadingHomeDataState extends AppStates {}

class AppSuccessHomeDataState extends AppStates {}

class AppErrorHomeDataState extends AppStates {}

class AppLoadingProfileDataState extends AppStates {}

class AppSuccessProfileDataState extends AppStates {
  final LoginModel loginModel;

  AppSuccessProfileDataState(this.loginModel);
}

class AppErrorProfileDataState extends AppStates {}

class AppSuccessCategoriesState extends AppStates {}

class AppErrorCategoriesState extends AppStates {}

class AppSuccessChangeFavState extends AppStates {
  final FavModel favModel;

  AppSuccessChangeFavState(this.favModel);
}

class AppSuccessChangeFavIconState extends AppStates {}

class AppErrorChangeFavIconState extends AppStates {}

class AppLoadingGetFavDataState extends AppStates {}

class AppSuccessGetFavDataState extends AppStates {}

class AppErrorGetFavDataState extends AppStates {}

class AppLoadingUpdateDataState extends AppStates {}

class AppSuccessUpdateDataState extends AppStates {
  final LoginModel loginModel;

  AppSuccessUpdateDataState(this.loginModel);
}

class AppErrorUpdateDataState extends AppStates {}
