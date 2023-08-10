import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/contents_screen/contents.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../layout/cubit/cubit.dart';
import '../../models/product_details_model.dart';
import '../../models/search_model.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            title: Form(
              key: formKey,
              child: DefaultForm(
                onChange: (p0) {
                  if (formKey.currentState!.validate()) {
                    SearchCubit.get(context)
                        .search(text: searchController.text);
                  }
                },
                controller: searchController,
                type: TextInputType.text,
                label: 'Search',
                preIcon: Icons.search,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Search for any Product';
                  }
                  return null;
                },
                submit: (p0) {
                  if (formKey.currentState!.validate()) {
                    SearchCubit.get(context)
                        .search(text: searchController.text);
                  }
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state is SearchLoadingState) LinearProgressIndicator(),
                ConditionalBuilder(
                  condition: state is SearchSuccessState,
                  builder: (BuildContext context) => ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                        onTap: () async {
                          await AppCubit.get(context).getProduct(id: SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data![index].id);
                          ProductDetailsModel detailsModel = AppCubit.get(context).productDetailsModel!;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PrevItem(detailsModel: detailsModel),));
                        },
                        child: SearchItem(
                            SearchCubit.get(context)
                                .searchModel!
                                .data!
                                .data![index],
                            context),
                      ),
                      separatorBuilder: (context, index) => Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                          ),
                      itemCount: SearchCubit.get(context)
                          .searchModel!
                          .data!
                          .data!
                          .length),
                  fallback: (BuildContext context) => Container(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget SearchItem(ProductData model, context) => Container(
        margin: EdgeInsets.all(20),
        height: 120,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                    width: 120,
                    fit: BoxFit.contain,
                    image: NetworkImage('${model.image}')),
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
                        '${model.price.round()} LE',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
