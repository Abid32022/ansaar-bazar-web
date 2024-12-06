import 'package:flutter/material.dart';

import '../util/app_colors.dart';

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor:AppColors.primarycolor,
  // secondaryHeaderColor: AppColors.primarycolor
  // disabledColor: Color(0xff6f7273),
  backgroundColor: Color(0xFFFFF8DC),
  errorColor: Color(0xFFdd3135),
  brightness: Brightness.dark,
  hintColor: Colors.black,
  cardColor: Color(0xFFFFF8DC),
  colorScheme: ColorScheme.dark(
      primary: Color(0xFF8B4512), secondary: Color(0xFFf47216)),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Color(0xFF8B4512))),
);
