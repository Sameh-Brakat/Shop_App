import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
}
