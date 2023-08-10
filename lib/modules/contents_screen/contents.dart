import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/product_details_model.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../search/cubit/states.dart';

class PrevItem extends StatelessWidget {
  PrevItem(
      {required this.detailsModel});

  final ProductDetailsModel detailsModel;


  var onBoardController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {
        // detailsModel == null ? state = ProductDetailsLoadingState as AppStates : state = ProductDetailsSuccessState as AppStates;
      },
      builder: (BuildContext context, Object? state) => Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color(0xff1d1f20),
          elevation: 0,
          actions: [
            IconButton(
              icon: CircleAvatar(
                  backgroundColor:
                  AppCubit.get(context).favorites[detailsModel.data?.id]!
                      ? Colors.amber
                      : Color.fromARGB(255, 212, 212, 210),
                  child: Icon(
                    AppCubit.get(context).favorites[detailsModel.data?.id]!
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 15,
                    color: AppCubit.get(context).favorites[detailsModel.data?.id]!
                        ? Colors.red
                        : Colors.black,
                  )),
              onPressed: () {
                AppCubit.get(context).changeFavIcon(detailsModel.data!.id);
              },
            )

          ],

        ),
        body: ConditionalBuilder(
          condition: state is! ProductDetailsLoadingState,
          builder: (BuildContext context) => Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .41,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                              controller: onBoardController,
                              physics: BouncingScrollPhysics(),
                              itemCount: detailsModel.data?.images!.length,
                              itemBuilder: (BuildContext context, int index) => Image.network(detailsModel.data!.images![index] ,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Align(
                                      alignment: Alignment.bottomCenter,child: LinearProgressIndicator());
                                },)
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmoothPageIndicator(
                                effect:
                                WormEffect(activeDotColor: Colors.blue, spacing: 10),
                                controller: onBoardController,
                                count: detailsModel.data!.images!.length),
                          ],
                        )
                      ],
                    ),
                  ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 10, top: 18),
                      child: Text(
                        detailsModel.data!.name!,
                        style: const TextStyle(
                          fontFamily: 'myfont',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(detailsModel.data!.description!,style: TextStyle(height: 2,fontSize: 17,fontWeight: FontWeight.w500)),
                    ),
                  SizedBox(height: 200,)
                ]),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text(
                              '${detailsModel.data?.price}',
                              style:
                              const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Text(
                              ' £',
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppCubit.get(context).addOrRemoveItemFromCart(detailsModel.data!.id);

                          // showGeneralDialog(
                          //   context: context,
                          //   barrierDismissible: true,
                          //   transitionDuration: Duration(milliseconds: 100),
                          //   barrierLabel:
                          //   MaterialLocalizations.of(context).dialogLabel,
                          //   barrierColor: Colors.black.withOpacity(0.5),
                          //   pageBuilder: (context, _, __) {
                          //     return Container(
                          //       height: 100,
                          //       child: Row(
                          //
                          //         children: [
                          //           OutlinedButton(
                          //             // style: ButtonStyle(col),
                          //               onPressed: () {
                          //
                          //           }, child: Text('Continue Shopping')),
                          //           OutlinedButton(
                          //             // style: ButtonStyle(col),
                          //               onPressed: () {
                          //
                          //               }, child: Text('Check Out'))
                          //
                          //         ],
                          //       ),
                          //     );
                          //   },
                          //   transitionBuilder:
                          //       (context, animation, secondaryAnimation, child) {
                          //     return SlideTransition(
                          //       position: CurvedAnimation(
                          //         parent: animation,
                          //         curve: Curves.easeOut,
                          //       ).drive(Tween<Offset>(
                          //         begin: Offset(0, -1.0),
                          //         end: Offset.zero,
                          //       )),
                          //       child: child,
                          //     );
                          //   },
                          // );
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * .5,
                            height: 60,
                            decoration: BoxDecoration(
                                color:AppCubit
                                    .get(context)
                                    .carts[detailsModel.data?.id!]!
                                    ? Color(0xff0f5ef5)
                                    : Color.fromARGB(255, 212, 212, 210) ,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                )),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // AppCubit.get(context).carts[detailsModel.data?.id] ? Icon(Icons.factory): null,
                                Text(
                                  "ADD TO CART",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'myfont',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          fallback: (BuildContext context) => LinearProgressIndicator(),
        ),
      ),
    );
  }
}
