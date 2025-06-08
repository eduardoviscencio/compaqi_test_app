import 'package:flutter/material.dart';

import 'package:compaqi_test_app/presentation/theme/colors.dart';
import 'package:compaqi_test_app/presentation/theme/font_sizes.dart';

class Decorations {
  static InputDecoration textFieldDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) => InputDecoration(
    prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: primaryColor, size: iconSize) : null,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: surfaceDarkerColor, width: .5),
    ),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: .5)),
    hintText: hintText,
    focusColor: backgroundColor,
    hintStyle: TextStyle(color: surfaceDarkerColor, fontSize: fontSizeText),
    floatingLabelStyle: TextStyle(color: primaryColor, fontSize: fontSizeText),
    labelText: labelText,
    labelStyle: TextStyle(color: surfaceDarkerColor, fontSize: fontSizeText),
  );
}
