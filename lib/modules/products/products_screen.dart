import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';

import '../../models/product_details_model.dart';
import '../../shared/components/components.dart';
import '../categories/category_products.dart';
import '../contents_screen/contents.dart';
import '../search/cubit/cubit.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSuccessChangeFavState) {
          if (!state.favModel.status) {
            Toastt(message: state.favModel.message, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AppCubit.get(context).homeModel != null &&
              AppCubit.get(context).categoriesModel != null,
          builder: (context) => ProductsBuilder(
              AppCubit.get(context).homeModel!,
              AppCubit.get(context).categoriesModel!,
              context),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget ProductsBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  height: 250.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 60),
                  autoPlayCurve: Curves.fastOutSlowIn),
              items: model.data?.banners
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.network('${e.image}' ,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Align(
                              alignment: Alignment.bottomCenter,child: LinearProgressIndicator());
                        },),
                      ))
                  .toList(),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => BuildCategoriesItem(
                          categoriesModel.data!.data[index],context),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 20,
                      ),
                      itemCount: categoriesModel.data!.data.length,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.count(
                childAspectRatio: 1 / 1.633,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: List.generate(
                    model.data!.products.length,
                    (index) => BuildGridProducts(
                        model.data!.products[index], context)),
              ),
            )
          ],
        ),
      );

  Widget BuildCategoriesItem(DataModel dataModel,context) => InkWell(
    onTap: () {

      Navigator.push(context, MaterialPageRoute(builder: (context) => CatProductsScreen(category_id: dataModel.id, category_name: dataModel.name,),));
    },
    child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage(dataModel.image),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Container(
                padding: EdgeInsets.only(top: 4, bottom: 4),
                width: 100,
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  dataModel.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
  );

  Widget BuildGridProducts(ProductsModel model, context) => Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              await AppCubit.get(context).getProduct(id: model.id);
              ProductDetailsModel detailsModel = AppCubit.get(context).productDetailsModel!;
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrevItem(detailsModel: detailsModel),));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      height: 200,
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
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, height: 1),
                ),
                Row(
                  children: [
                    Text(
                      '${model.price.round()} LE',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    model.old_price == model.price
                        ? Text('')
                        : Text(
                            '${model.old_price.round()} LE',
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
                              AppCubit.get(context).favorites[model.id]!
                                  ? Colors.amber
                                  : Color.fromARGB(255, 212, 212, 210),
                          child: Icon(
                            AppCubit.get(context).favorites[model.id]!
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 15,
                            color: AppCubit.get(context).favorites[model.id]!
                                ? Colors.red
                                : Colors.black,
                          )),
                      onPressed: () {
                        AppCubit.get(context).changeFavIcon(model.id);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
