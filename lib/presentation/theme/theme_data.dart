import 'package:flutter/material.dart';

import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';

ThemeData themeData = ThemeData(
  fontFamily: 'Inter',
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: backgroundColor,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: surfaceColor,
    contentTextStyle: TextStyle(color: primaryColor, fontSize: fontSizeText, fontFamily: 'Inter'),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: surfaceColor,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: primaryColor),
    titleTextStyle: TextStyle(
      color: primaryColor,
      fontSize: fontSizeH1,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
    centerTitle: true,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: TextStyle(fontSize: fontSizeText, fontFamily: 'Inter'),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: primaryColor,
    selectionHandleColor: primaryColor,
  ),
);
