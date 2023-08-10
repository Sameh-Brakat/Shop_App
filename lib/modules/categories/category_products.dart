import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/category_products.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/product_details_model.dart';
import '../contents_screen/contents.dart';
import '../search/cubit/cubit.dart';

  class CatProductsScreen extends StatelessWidget {

  const CatProductsScreen({super.key, required this.category_id, required this.category_name});
  final int category_id;
  final String category_name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..categoryProducts(category_id),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(category_name),
            ),
            body: ConditionalBuilder(
              condition: state is! AppLoadingGetCatProductsState,
              builder: (BuildContext context) => ListView.separated(
                itemBuilder: (context, index) => ProductItem(
                    AppCubit.get(context).getCatProductsModel!.data!.data![index],
                    context),
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                ),
                itemCount: AppCubit.get(context).getCatProductsModel!.data!.data!.length,
              ),
              fallback: (BuildContext context) =>
                  Scaffold(body: Center(child: CircularProgressIndicator())),
            ),
          );
        },
      ),
    );
  }

  Widget ProductItem(ProData model, context) => InkWell(
    onTap: () async {

      await AppCubit.get(context).getProduct(id: model.id);
      ProductDetailsModel detailsModel = AppCubit.get(context).productDetailsModel!;
      Navigator.push(context, MaterialPageRoute(builder: (context) => PrevItem(detailsModel: detailsModel),));

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
                      fontWeight: FontWeight.w900, fontSize: 18, height: 1.3),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price} LE',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    model.oldPrice == model.price
                        ? Text('')
                        : Text(
                      '${model.oldPrice} LE',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    // Spacer(),
                    // IconButton(
                    //   icon: CircleAvatar(
                    //       backgroundColor:
                    //       AppCubit.get(context).favorites[model.id!]!
                    //           ? Colors.amber
                    //           : Color.fromARGB(255, 212, 212, 210),
                    //       child: Icon(
                    //         AppCubit.get(context).favorites[model.id!]!
                    //             ? Icons.favorite
                    //             : Icons.favorite_border,
                    //         size: 15,
                    //         color: AppCubit.get(context).favorites[model.id!]!
                    //             ? Colors.red
                    //             : Colors.black,
                    //       )),
                    //   onPressed: () {
                    //     AppCubit.get(context).changeFavIcon(model.id!);
                    //   },
                    // )
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
