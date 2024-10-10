import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors{
  static const primary= Color(0xff0060e5);
  static const secondary= Color(0xFF1c86ff);
  static const background= Color(0xfff2f4f7);
  static const white= Color(0xffffffff);
  static const draft= Color(0xffcde0fa);
  static const gateInRed= Color(0xffffd1d1);
  static const gateInYellow= Color(0xfffcdd9f);
  static const gatedIn= Color(0xffb4d9b5);
  static const gradient1= Color(0xffF2F7FD);
  static const gradient2= Color(0xffCCDFFA);
  static const cardTextColor= Color(0xff184565);
  static const textColorPrimary= Color(0xff1F2933);
  static const textColorSecondary= Color(0xff616E7C);
  static const containerBgColor= Color(0xffCCF1F6);
  static const textFieldBorderColor= Color(0xff9AA5B1);
 static const MaterialColor primaryColorSwatch = MaterialColor(0xff0060e6, <int, Color>{
  50: Color(0xff0060e6),
  100: Color(0xff0060e6),
  200: Color(0xff0060e6),
  300: Color(0xff0060e6),
  400: Color(0xff0060e6),
  500: Color(0xff0060e6),
  600: Color(0xff0060e6),
  700: Color(0xff0060e6),
  800: Color(0xff0060e6),
  900: Color(0xff0060e6),
  },);

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}