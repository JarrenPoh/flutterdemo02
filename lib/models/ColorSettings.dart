import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kMain2Color = Color.fromARGB(165, 254, 151, 99);
const kMaim3Color = Color(0x85ED1C24);
const kMaimColor = Color.fromRGBO(237, 28, 36, 1);
const kSecondaryColor = Color.fromARGB(255, 241, 90, 36);
const kThirdColor = Color(0xFFB41020);
const kBodyTextColor = Color.fromARGB(255, 27, 27, 27);
const kTextLightColor = Color.fromRGBO(106, 114, 125, 1);
const kActiveColor = Color.fromARGB(252, 5, 201, 207);
final kBottomColor = Colors.grey[200];

const double defaultPadding = 15.0;
final categoryHeight = Get.context!.height / 11.78; //70
final productHeight = Get.context!.height / 6.34; //130

class Dimensions {
  static double screenHeigt = Get.context!.height; //825
  static double screenWidth = Get.context!.width; //392

  ////height825
  static double form3ItemCard = screenHeigt / 3.3; //250
  static double form3ItemCardContainer = screenHeigt / 4.34; //190
  static double form3ItemCardTextContainer = screenHeigt / 10.31; //80

  static double height5 = screenHeigt / 165; //10
  static double height10 = screenHeigt / 82.5; //10
  static double height15 = screenHeigt / 55; //15
  static double height20 = screenHeigt / 41.25; //20
  static double height50 = screenHeigt / 16.5; //50

  static double fontsize13 = screenHeigt / 63.46; //13
  static double fontsize14 = screenHeigt / 58.57; //14 tab
  static double fontsize16 = screenHeigt / 51.25; //16 betwwen
  static double fontsize18 = screenHeigt / 45.83; //18 middle
  static double fontsize24 = screenHeigt / 37.5; //22

  static double radius20 = screenHeigt / 41.25; //20
  static double radius15 = screenHeigt / 55; //15
  static double radius10 = screenHeigt / 82.5; //10
  static double radius5 = screenHeigt / 164; //5

  static double icon32 = screenHeigt / 25.625; //32
  static double icon25 = screenHeigt / 33; //25
  ////

  ////width392
  static double width10 = screenWidth / 39.2; //10
  static double width15 = screenWidth / 26.13; //15
  static double width20 = screenWidth / 19.6; //20
}
