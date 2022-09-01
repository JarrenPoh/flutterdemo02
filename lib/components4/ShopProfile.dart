import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

import '../models/MiddleText.dart';
import '../models/TabsText.dart';

class ShopProfile extends StatefulWidget {
  ShopProfile({Key? key, required this.arguments}) : super(key: key);
  Map arguments;
  @override
  State<ShopProfile> createState() => ShopProfileState(arguments: arguments);
}

class ShopProfileState extends State<ShopProfile> {
  ShopProfileState({required this.arguments});
  get kBodyTextColor => null;
  Map arguments;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.height10, horizontal: Dimensions.width15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiddleText(
            color: kBodyTextColor,
            text: arguments['shopname'],
            fontFamily: 'NotoSansMedium',
            maxlines: 2,
          ),
          SizedBox(
            height: Dimensions.height5,
          ),
          TabText(
            color: kTextLightColor,
            text:
                '自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行自我介紹最長就五行',
            maxLines: 5,
          ),
          SizedBox(
            height: Dimensions.height10,
          ),
          // if (arguments['delivertime'] == null)

          if (arguments['delivertime'] != null)
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: kMaimColor,
                  size: Dimensions.icon25,
                ),
                SizedBox(
                  width: Dimensions.width10,
                ),
                TabText(
                  color: kBodyTextColor,
                  text: '備餐時間: ${arguments['delivertime']} 分鐘',
                  fontFamily: 'NotoSansMedium',
                ),
              ],
            ),
          // if (arguments['discountprice'] == null)
          //   SizedBox(
          //     height: Dimensions.height10,
          //   ),
          if (arguments['discountprice'] != null)
            Row(
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  color: kMaimColor,
                  size: Dimensions.icon25,
                ),
                SizedBox(
                  width: Dimensions.width10,
                ),
                TabText(
                  color: kBodyTextColor,
                  text:
                      '消費: 滿 ${arguments['discountnumber']} 送 ${arguments['discountprice']} 元',
                  fontFamily: 'NotoSansMedium',
                ),
              ],
            ),
          SizedBox(
            height: Dimensions.height20,
          ),
        ],
      ),
    );
  }
}
