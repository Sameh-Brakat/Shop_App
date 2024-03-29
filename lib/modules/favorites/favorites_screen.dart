import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/get_fav_model.dart';
import 'package:shop_app/models/product_details_model.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../contents_screen/contents.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! AppLoadingGetFavDataState,
          builder: (BuildContext context) =>
              ListView.separated(
                itemBuilder: (context, index) =>
                    FavItem(
                        AppCubit
                            .get(context)
                            .getFavModel!
                            .data!
                            .data![index].product!,
                        context),
                separatorBuilder: (context, index) =>
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                    ),
                itemCount: AppCubit
                    .get(context)
                    .getFavModel!
                    .data!
                    .data!
                    .length,
              ),
          fallback: (BuildContext context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget FavItem(Product model, context) =>
      InkWell(
        onTap: () async{


          await AppCubit.get(context).getProduct(id: model.id);
          ProductDetailsModel detailsModel = AppCubit.get(context).productDetailsModel!;


          // print(detailsModel.data?.id);


          Navigator.push(context, MaterialPageRoute(builder: (context) => PrevItem(detailsModel: detailsModel),));

          // SearchCubit searchCubit = SearchCubit.get(context);
          // searchCubit.searchProduct(text: '', desiredId: model.id!);
          //
          // SearchModel? searchModel = searchCubit.getSearchModel();
          // List<String>? images = searchCubit.getImageList();
          //
          // if (searchModel != null && images != null) {
          //   // Access the search results and image list
          //   // ...
          // } else {
          //   // Handle the case when search results or image list are not available
          //   // ...
          // }


          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
          //     PrevItem(id: model.id!,),));
        },
        child: Container(
          margin: EdgeInsets.all(20),
          height: 120,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    width: 120,
                    child: Image.network(
                        '${model.image}',
                        width: double.infinity,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Align(
                              alignment: Alignment.bottomCenter,child: LinearProgressIndicator());
                        }
                    ),
                  ),
                  if (model.discount != 0)
                    Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '-${model.discount}%',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${model.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          height: 1.3),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          '${model.price.round()} LE',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        model.oldPrice == model.price
                            ? Text('')
                            : Text(
                          '${model.oldPrice.round()} LE',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: CircleAvatar(
                              backgroundColor:
                              AppCubit
                                  .get(context)
                                  .favorites[model.id!]!
                                  ? Colors.amber
                                  : Color.fromARGB(255, 212, 212, 210),
                              child: Icon(
                                AppCubit
                                    .get(context)
                                    .favorites[model.id!]!
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 15,
                                color: AppCubit
                                    .get(context)
                                    .favorites[model.id!]!
                                    ? Colors.red
                                    : Colors.black,
                              )),
                          onPressed: () {
                            AppCubit.get(context).changeFavIcon(model.id!);
                            print(model.id);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
