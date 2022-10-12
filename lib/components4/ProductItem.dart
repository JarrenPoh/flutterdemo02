import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/MenuModel.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/pages/Tabs.dart';

import '../models/MiddleText.dart';

class RappiProductItem extends StatefulWidget {
  Map arguments;
  RappiProductItem(this.product, this.arguments);
  final Result product;

  @override
  State<RappiProductItem> createState() =>
      _RappiProductItemState(arguments: arguments);
}

class _RappiProductItemState extends State<RappiProductItem> {
  Map arguments;
  _RappiProductItemState({required this.arguments});
  List options = [];

  bool? businessTime;
  int selectedHour = TimeOfDay.now().hour;
  @override
  void initState() {
    if (arguments['businessTime'][selectedHour] == true) {
      print('營業中');
      businessTime = true;
    } else {
      print('尚未營業');
      businessTime = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product.options != null) {
      options = jsonDecode(widget.product.options!);
    }

    return SizedBox(
      height: productHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
        child: GestureDetector(
          onTap: () async {
            if (businessTime == true) {
              cartController.deleteindex = null;
              final choses = await Navigator.pushNamed(
                context,
                '/form5',
                arguments: {
                  'id': true,
                  'Id': widget.product.id,
                  'name': widget.product.name,
                  'price': int.parse(widget.product.price),
                  'textprice': widget.product.price,
                  'description': widget.product.describe,
                  'image': widget.product.image,
                  'shopname': widget.arguments['shopname'],
                  'ToCart': '加入購物車',
                  'firstNumber': 1,
                  'options': options,
                },
              );
            } else if (businessTime == false) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: MiddleText(
                    color: kBodyTextColor,
                    text: '店家尚未營業',
                    fontFamily: 'NotoSansMedium',
                  ),
                  content: Column(
                    children: [
                      TabText(
                        color: kBodyTextColor,
                        text: '很抱歉，店家未營業時無法訂購餐點',
                        fontFamily: 'NotoSansMedium',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: TabText(
                        color: Colors.blue,
                        text: '知道了',
                        fontFamily: 'NotoSansMedium',
                      ),
                    ),
                  ],
                ),
              );
              setState(() {});
            }
          },
          child: Card(
            elevation: Dimensions.height5,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: Dimensions.width10,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: Dimensions.width10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BetweenSM(
                          color: kBodyTextColor,
                          text: widget.product.name,
                          weight: FontWeight.normal,
                          fontFamily: 'NotoSansMedium',
                        ),
                        if (widget.product.describe != null)
                          SmallText(
                            color: kTextLightColor,
                            text: widget.product.describe!,
                          ),
                        SizedBox(
                          height: Dimensions.height5,
                        ),
                        Text(
                          '\$ ${widget.product.price}',
                          style: const TextStyle(
                              color: kMaimColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              fontFamily: 'NotoSansMedium'),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                      horizontal: Dimensions.width10),
                  child: SizedBox(
                    height: Dimensions.screenHeigt / 9.17,
                    width: Dimensions.screenWidth / 4.36,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      child: Column(
                        children: [
                          if (widget.product.image != null)
                            Image.asset(
                              widget.product.image!,
                              fit: BoxFit.cover,
                            ),
                          if (widget.product.image == null)
                            Container(
                              color: Colors.grey,
                              width: Dimensions.screenWidth / 4.36,
                              height: Dimensions.screenHeigt / 9.17,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
