import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/product_details_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../models/fav_model.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);


  SearchModel? searchModel;

  void search({required String? text}) {
    emit(SearchLoadingState());

    DioHelper.postData(url: SEARCH, data: {
      'text': text,
    }).then((value) {
      searchModel = SearchModel.fromJson(value?.data);
      
      emit(SearchSuccessState(searchModel!));
    }).catchError((error) {
      print(error);
      emit(SearchErrorState(error.toString()));
    });

  }


  
  

  // void searchProduct({required String? text, required int desiredId}) {
  //   emit(SearchLoadingState());
  //
  //   DioHelper.postData(url: SEARCH, data: {
  //     'text': text,
  //   }).then((value) {
  //     searchModel = SearchModel.fromJson(value?.data);
  //
  //     // Find the desired product by matching the ID
  //     ProductData? desiredProduct;
  //     if (searchModel?.data != null) {
  //       desiredProduct = searchModel?.data!.data!.firstWhere((product) => product.id == desiredId,);
  //     }
  //
  //     if (desiredProduct != null) {
  //       // Retrieve the images and save them in a list
  //       List<String> imageList = [];
  //       if (desiredProduct.images != null) {
  //         for (var image in desiredProduct.images!) {
  //           imageList.add(image);
  //         }
  //       }
  //
  //       emit(SearchSuccessState(searchModel!));
  //     } else {
  //       emit(SearchErrorState('Product with ID $desiredId not found'));
  //     }
  //   }).catchError((error) {
  //     print(error);
  //     emit(SearchErrorState(error.toString()));
  //   });
  // }
  //
  // List<String>? imageList;
  //
  // // Getter method to access the search results
  // SearchModel? getSearchModel() {
  //   return searchModel;
  // }
  //
  // List<String>? getImageList() {
  //   return imageList;
  // }

}
