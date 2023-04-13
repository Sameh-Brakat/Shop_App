import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/fav_model.dart';
import 'package:shop_app/models/get_fav_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/login_model.dart';
import '../../shared/end_points.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomNavScreen = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavScreen(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  Map<int, bool> favorites = {};

  HomeModel? homeModel;

  void getHomeData() {
    emit(AppLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print(value.data);
      homeModel!.data?.products.forEach((element) {
        favorites.addAll({
          element.id: element.in_favorites,
        });
      });
      print(favorites.toString());
      // printFullText(homeModel.toString());
      // printFullText(homeModel?.status.toString());
      // printFullText(homeModel?.data?.banners.toString());

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
      print(value.data);
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
      print(value.data);
      // printFullText(homeModel.toString());
      // printFullText(homeModel?.status.toString());
      // printFullText(homeModel?.data?.banners.toString());

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
      print(value!.data);
      if (!favModel!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavData();
      }

      print(value.data);

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
      print(value.data);
      emit(AppSuccessGetFavDataState());
    }).catchError((e) {
      print(e);
      emit(AppErrorGetFavDataState());
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
}
