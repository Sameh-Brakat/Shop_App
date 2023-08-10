import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/fav_model.dart';
import 'package:shop_app/models/get_fav_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/carts/cart_screen.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/cart_model.dart';
import '../../models/category_products.dart';
import '../../models/login_model.dart';
import '../../models/product_details_model.dart';
import '../../shared/end_points.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomNavScreen = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    CartsScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavScreen(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  Map<int, bool> favorites = {};
  Map<int, bool> carts = {};

  HomeModel? homeModel;

  void getHomeData() {
    emit(AppLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data?.products.forEach((element) {
        favorites.addAll({
          element.id: element.in_favorites,
        });
        carts.addAll({
          element.id: element.in_cart,
        });
      });

      emit(AppSuccessHomeDataState());
    }).catchError((e) {
      print(e);
      emit(AppErrorHomeDataState());
    });
  }

  LoginModel? profileModel;

  void getProfileData() {
    emit(AppLoadingProfileDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      profileModel = LoginModel.fromJson(value.data);
      emit(AppSuccessProfileDataState(profileModel!));
    }).catchError((e) {
      print(e);
      emit(AppErrorProfileDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    emit(AppLoadingHomeDataState());

    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(AppSuccessCategoriesState());
    }).catchError((e) {
      print(e);
      emit(AppErrorCategoriesState());
    });
  }










  FavModel? favModel;

  void changeFavIcon(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(AppSuccessChangeFavIconState());

    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      favModel = FavModel.fromJson(value?.data);

      if (!favModel!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavData();
      }
      emit(AppSuccessChangeFavState(favModel!));
    }).catchError((e) {
      favorites[productId] = !favorites[productId]!;
      print(e);
      emit(AppErrorChangeFavIconState());
    });
  }

  GetFavModel? getFavModel;

  void getFavData() {
    emit(AppLoadingGetFavDataState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      getFavModel = GetFavModel.fromJson(value.data);
      emit(AppSuccessGetFavDataState());
    }).catchError((e) {
      print(e);
      emit(AppErrorGetFavDataState());
    });
  }

  //////////////////////////////////////////////////////////////////////

  CatModel1? catModel1;
  CartModel? cartModel;
  void addOrRemoveItemFromCart(int productId) {
    carts[productId] = !carts[productId]!;
    emit(ChangeCartIconSuccessState());

    DioHelper.postData(
      url: CARTS,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      catModel1 = CatModel1.fromJson(value?.data);

      if (!catModel1!.status) {
        carts[productId] = !carts[productId]!;
      } else {
        getCartsData();
      }
      emit(ChangeCartSuccessState(catModel1!));
    }).catchError((e) {
      carts[productId] = !carts[productId]!;
      print(e);
      emit(ChangeCartIconErrorState());
    });
  }


  void getCartsData() {
    emit(GetCartDataLoadingState());

    DioHelper.getData(
      url: CARTS,
      token: token,
    ).then((value) {
      cartModel = CartModel.fromJson(value.data);
      emit(GetCartDataSuccessState());
    }).catchError((e) {
      print(e);
      emit(GetCartDataErrorState());
    });
  }




















  void updateData({String? name, String? email, String? phone}) {
    emit(AppLoadingUpdateDataState());

    DioHelper.updateData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      profileModel = LoginModel.fromJson(value.data);
      print(value.data);
      emit(AppSuccessUpdateDataState(profileModel!));
    }).catchError((e) {
      print(e);
      emit(AppErrorUpdateDataState());
    });
  }


  GetCatProductsModel? getCatProductsModel;
  void categoryProducts(int category_id){
    emit(AppLoadingGetCatProductsState());

    DioHelper.getData(url: PRODUCTS, query: {"category_id": category_id}).then((value) {
      getCatProductsModel = GetCatProductsModel.fromJson(value.data);
      print("this is products ${value.data}");
      emit(AppSuccessGetCatProductsState());
    }).catchError((e){
      print("this is error $e");
      emit(AppErrorGetCatProductsState());
    });
  }




  ProductDetailsModel? productDetailsModel;

  Future getProduct({required id}) {
    emit(ProductDetailsLoadingState());

    return DioHelper.getData(url: '$PRODUCTS/$id').then((value) {

      productDetailsModel = ProductDetailsModel.fromJson(value.data);

      emit(ProductDetailsSuccessState(productDetailsModel!));
    }).catchError((e) {
      print(e);
      emit(ProductDetailsErrorState());
    });
  }
}
