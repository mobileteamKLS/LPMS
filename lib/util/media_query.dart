import 'package:flutter/cupertino.dart';

class ScreenDimension {
  static late double screenWidth;
  static late double screenHeight;
  static late double onePercentOfScreenWidth;
  static late double onePercentOfScreenHight;

  static late double textSize;
  static late double imageSize;
  static late double heightMultiplier;


  static final ScreenDimension _instance = ScreenDimension._internal();

  factory ScreenDimension() {
    return _instance;
  }

  ScreenDimension._internal();

  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    onePercentOfScreenWidth = screenWidth / 100;
    onePercentOfScreenHight = screenHeight / 100;

    textSize = onePercentOfScreenHight;
    imageSize = onePercentOfScreenWidth;
    heightMultiplier = onePercentOfScreenHight;
  }
}
