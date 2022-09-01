import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/MenuModel.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/pages/Tabs.dart';

class RappiProductItem extends StatelessWidget {
  Map arguments;
  RappiProductItem(this.product, this.arguments);
  final Result product;
  List options = [];
  @override
  Widget build(BuildContext context) {
    if (product.options != null) {
      options = jsonDecode(product.options!);
    }

    return SizedBox(
      height: productHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
        child: GestureDetector(
          onTap: () async {
            cartController.deleteindex = null;
            final choses =
                await Navigator.pushNamed(context, '/form5', arguments: {
              'id': true,
              'Id': product.id,
              'name': product.name,
              'price': int.parse(product.price),
              'textprice': product.price,
              'description': product.describe,
              'image': product.image,
              'shopname': arguments['shopname'],
              'ToCart': '加入購物車',
              'firstNumber': 1,
              'options': options,
            });
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
                            text: product.name,
                            weight: FontWeight.normal,
                            fontFamily: 'NotoSansMedium',
                          ),
                          if (product.describe != null)
                            SmallText(
                              color: kTextLightColor,
                              text: product.describe!,
                            ),
                          SizedBox(
                            height: Dimensions.height5,
                          ),
                          Text(
                            '\$ ${product.price}',
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
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                        child: Column(
                          children: [
                            if (product.image != null)
                              Image.asset(
                                product.image!,
                                fit: BoxFit.cover,
                              ),
                            if (product.image == null)
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
              )),
        ),
      ),
    );
  }
}
