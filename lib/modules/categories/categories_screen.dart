import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';

import 'category_products.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) => BuildCatsItem(context,
              AppCubit.get(context).categoriesModel!.data!.data[index]),
          separatorBuilder: (context, index) => Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: 5),
          ),
          itemCount: AppCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }
}

Widget BuildCatsItem(context,DataModel dataModel) => InkWell(
  onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CatProductsScreen(category_id: dataModel.id, category_name: dataModel.name,),));
  },
  child:   Padding(

        padding: const EdgeInsets.all(20.0),

        child: Row(

          children: [

            Container(
              height: 120,
              width: 120,
              child: Image.network(
                  dataModel.image,

                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Align(
                        alignment: Alignment.bottomCenter,child: LinearProgressIndicator());
                  }
              ),
            ),

            SizedBox(

              width: 20,

            ),

            Text(

              dataModel.name,

              style: TextStyle(

                fontSize: 20,

                fontWeight: FontWeight.bold,

              ),

            ),

            Spacer(),

            Icon(Icons.keyboard_arrow_right, size: 40),

          ],

        ),

      ),
);



// ConditionalBuilder(
        //   condition: AppCubit.get(context).categoriesModel != null,
        //   builder: (context) =>
        //       ProductsBuilder(AppCubit.get(context).homeModel!),
        //   fallback: (context) => Center(
        //     child: CircularProgressIndicator(),
        //   ),
        // );