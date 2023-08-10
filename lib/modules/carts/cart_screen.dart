import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/product_details_model.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/cart_model.dart';
import '../../shared/components/constants.dart';
import '../contents_screen/contents.dart';

class CartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! GetCartDataLoadingState,
          builder: (BuildContext context) => Stack(
            children: [
              ListView.separated(
                itemBuilder: (context, index) =>
                    CartItem(
                        AppCubit
                            .get(context).cartModel!.data!.cartItems![index].product!,
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
                    .cartModel!.data!.cartItems!.length,
              ),
              Positioned(
                  left: 5,
                  right: 5,
                  bottom: 5,
                  child: Container(
                    width: double.infinity, // Occupy full width
                    height: 60,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: () {
                        // Button action
                      },
                      color: defaultColorLight,
                      textColor: Colors.white,
                      child: Text('BUY ${AppCubit
                          .get(context)
                          .cartModel!.data!.cartItems!.length} ITEMS FOR ${AppCubit
                          .get(context)
                          .cartModel!.data!.total} EGP'),
                    ),
                  ))
            ],
          ),
          fallback: (BuildContext context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget CartItem(Product model, context) =>
      InkWell(
        onTap: () async{
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
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          height: 1.3),
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
