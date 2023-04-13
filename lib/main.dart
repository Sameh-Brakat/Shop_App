import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/onboarding_screen.dart';
import 'modules/search/cubit/cubit.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/network/local/cashe_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;

  dynamic onBoarding = CacheHelper.getData(key: 'onBoard');
  token = CacheHelper.getData(key: 'token');
  print(token);
  // print(HomeModel.fromJson(json));

  if (onBoarding != null) {
    if (token != null)
      widget = HomeLayout();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  // final dynamic onBoarding;
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavData()
            ..getProfileData(),
        ),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => SearchCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        home: startWidget,
        // onBoarding ? LoginScreen() : OnBoardingScreen(),
      ),
    );
  }
}
