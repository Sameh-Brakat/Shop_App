import 'package:flutter/material.dart';

import '../../modules/login/login_screen.dart';
import '../network/local/cashe_helper.dart';

const defaultColorLight = Colors.orange;
const defaultColorDark = Colors.blue;

dynamic token = '';

void SignOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
  });
}

void printFullText(dynamic text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((element) => print(element.group(0)));
}
