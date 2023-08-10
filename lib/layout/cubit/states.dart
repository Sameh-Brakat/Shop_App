import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/fav_model.dart';
import 'package:shop_app/models/login_model.dart';

import '../../models/product_details_model.dart';

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

////////////////////////////////////////////////////////////////
//changeIconCart
class ChangeCartIconSuccessState extends AppStates {}

class ChangeCartSuccessState extends AppStates {
  final CatModel1 catModel1;

  ChangeCartSuccessState(this.catModel1);
}

class ChangeCartIconErrorState extends AppStates {}

///////////////

class GetCartDataLoadingState extends AppStates {}

class GetCartDataSuccessState extends AppStates {}

class GetCartDataErrorState extends AppStates {}

////////////////////////////////////////////////////////////////

class AppLoadingGetFavDataState extends AppStates {}

class AppSuccessGetFavDataState extends AppStates {}

class AppErrorGetFavDataState extends AppStates {}

class AppLoadingUpdateDataState extends AppStates {}

class AppSuccessUpdateDataState extends AppStates {
  final LoginModel loginModel;

  AppSuccessUpdateDataState(this.loginModel);
}

class AppErrorUpdateDataState extends AppStates {}



// GetCatProducts
class AppLoadingGetCatProductsState extends AppStates {}

class AppSuccessGetCatProductsState extends AppStates {}

class AppErrorGetCatProductsState extends AppStates {}

// ProductDetails
class ProductDetailsLoadingState extends AppStates {}

class ProductDetailsSuccessState extends AppStates {
  final ProductDetailsModel detailsModel;

  ProductDetailsSuccessState(this.detailsModel);
}

class ProductDetailsErrorState extends AppStates {}

////////////////////////////////////////////////////////////////
// CartProducts
class CartProductsLoadingState extends AppStates {}

class CartProductsSuccessState extends AppStates {
  final ProductDetailsModel detailsModel;

  CartProductsSuccessState(this.detailsModel);
}

class CartProductsErrorState extends AppStates {}