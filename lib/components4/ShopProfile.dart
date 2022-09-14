import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

import '../models/MiddleText.dart';
import '../models/SmallText.dart';
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
    List discount = arguments['discount'];
    String shopname = arguments['shopname'];
    String describe = arguments['describe'];
    String? timeEstimate = arguments['timeEstimate'];
    bool businessTime;
    int selectedHour = TimeOfDay.now().hour;
    if ( arguments['businessTime'][selectedHour] == true) {
      print('營業中');
      businessTime = true;
    } else {
      print('尚未營業');
      businessTime = false;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height5,
        horizontal: Dimensions.width15,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiddleText(
            color: kBodyTextColor,
            text: shopname,
            fontFamily: 'NotoSansMedium',
            maxlines: 2,
          ),
          SizedBox(
            height: Dimensions.height5,
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: Dimensions.width10 / 2),
                    width: Dimensions.width15 / 2,
                    height: Dimensions.width15 / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius20,
                      ),
                      color: businessTime ? Colors.green : kMaimColor,
                    ),
                  ),
                  SmallText(
                    text: businessTime ? '營業中' : '尚未營業',
                    color: kBodyTextColor,
                    fontFamily: 'NotoSansMedium',
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
            ],
          ),
          if (describe != '')
            Column(
              children: [
                TabText(
                  color: kTextLightColor,
                  text: '${describe}',
                  maxLines: 10,
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
              ],
            ),

          // if (arguments['delivertime'] == null)

          if (timeEstimate != null)
            Column(
              children: [
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
                      text: '備餐時間: ${timeEstimate} 分鐘',
                      fontFamily: 'NotoSansMedium',
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
              ],
            ),
          // if (arguments['discountprice'] == null)
          //   SizedBox(
          //     height: Dimensions.height10,
          //   ),

          if (discount.isNotEmpty)
            Column(
              children: [
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
                          '消費: 滿 ${discount[0]['goal']} 送 ${discount[0]['discount']} 元',
                      fontFamily: 'NotoSansMedium',
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
