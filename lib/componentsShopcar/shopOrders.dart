import 'dart:convert';
import 'dart:developer';
import 'package:flutterdemo02/componentsShopcar/emptyshopCar.dart';
import 'package:flutterdemo02/pages/Form5.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';
import 'package:http/http.dart' as http;
import 'package:flutterdemo02/API/shopCarApi.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import 'package:get/get.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';

import '../API/shopCarModel.dart';
import '../models/MiddleText.dart';
import '../provider/Shared_Preference.dart';

class shopOrders extends StatefulWidget {
  shopOrders({
    Key? key,
    required this.notifyParent,
  }) : super(key: key);
  Function() notifyParent;
  @override
  State<shopOrders> createState() =>
      _shopOrdersState(notifyParent: notifyParent);
}

class _shopOrdersState extends State<shopOrders> {
  _shopOrdersState({required this.notifyParent});
  final CartController cartController = Get.find();
  Function() notifyParent;
  @override
  Widget build(BuildContext context) {
    // MyProvider provider=Provider.of<MyProvider>(context);
    return Obx(
      () => Column(
        children: [
          ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width15),
              child: Text(
                '訂單內容',
                style: TextStyle(fontSize: Dimensions.fontsize24),
              ),
            ),
            subtitle: Column(
              children: List.generate(
                cartController.cartlist.length,
                (index) {
                  var name = cartController.cartlist[index].name;
                  var price = cartController.cartlist[index].price;
                  var firstNumber = cartController.cartlist[index].quantity;
                  var radiopricesnum =
                      cartController.cartlist[index].radiopricesnum;
                  var Radiopricesnum =
                      cartController.cartlist[index].Radiopricesnum;
                  /////把[[布丁,仙草],[仙草]]變成'[布丁,仙草][仙草]'
                  var list = cartController.cartlist[index].radiolist;
                  var Stringlist = list!.join('');
                  var List = cartController.cartlist[index].Radiolist;
                  var StringList = List!.join('').replaceAll(r'[]', '');
                  /////
                  return InkWell(
                    onTap: () async {
                      cartController.GetupdateDeleteIndex(index);

                      ///加await的東西，回來還要再跑一次，或setstate或inspect
                      await Navigator.push(
                        context,
                        CustomPageRoute(
                          child: FormPage5(
                            arguments: {
                              'id': false,
                              'name': cartController.cartlist[index].name,
                              'price': cartController.cartlist[index].price,
                              'textprice':
                                  cartController.cartlist[index].textprice,
                              'description':
                                  cartController.cartlist[index].description,
                              'shopname':
                                  cartController.cartlist[index].shopname,
                              'ToCart': '更新購物車',
                              'firstNumber':
                                  cartController.cartlist[index].quantity,
                              'radiolist':
                                  cartController.cartlist[index].radiolist,
                              'addCheckBool':
                                  cartController.cartlist[index].addCheckBool,
                              'radioprices':
                                  cartController.cartlist[index].radioprices,
                              'radiopricesnum':
                                  cartController.cartlist[index].radiopricesnum,
                              'text': cartController.cartlist[index].text,
                              'options': cartController.cartlist[index].options,
                              'requiredCheckBool': cartController
                                  .cartlist[index].requiredCheckBool,
                              'Radiolist':
                                  cartController.cartlist[index].Radiolist,
                              'Radioprices':
                                  cartController.cartlist[index].Radioprices,
                              'Radiopricesnum':
                                  cartController.cartlist[index].Radiopricesnum,
                              'Id': cartController.cartlist[index].id,
                              'imageUrl':
                                  cartController.cartlist[index].imageUrl,
                            },
                          ),
                        ),
                      );
                      widget.notifyParent();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              bottom: Dimensions.height10,
                              left: Dimensions.width15),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: TabText(
                                        color: kTextLightColor,
                                        text:
                                            '${cartController.cartlist[index].quantity}'),
                                    color: Colors.grey[200],
                                    width: Dimensions.height15 * 2,
                                    height: Dimensions.height15 * 2,
                                    padding: EdgeInsets.only(
                                      bottom: Dimensions.height10 / 6,
                                      left: Dimensions.width10,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MiddleText(
                                          color: kBodyTextColor,
                                          text: name,
                                          fontFamily: 'NotoSansMedium',
                                          maxlines: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: const [],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.height5),
                                    child: Text(
                                      '${(price + Radiopricesnum! + radiopricesnum!) * firstNumber}',
                                      style: TextStyle(
                                          color: kBodyTextColor,
                                          fontSize: Dimensions.fontsize18),
                                    ),
                                  ),
                                  IconButton(
                                    alignment: Alignment.topRight,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      cartController.delete(index);
                                      if (cartController.cartlist.isEmpty) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                emptyShopCar(),
                                          ),
                                        );
                                      } else if (cartController
                                          .cartlist.isNotEmpty) {
                                        cartController.ifUpdate(name: true);
                                        widget.notifyParent();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: kMaimColor,
                                      size: Dimensions.width20,
                                    ),
                                  ),
                                ],
                              ),
                              ////radioValue 必選
                              if (cartController
                                  .cartlist[index].radiolist!.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: Dimensions.height15 * 2,
                                      height: Dimensions.height15 * 2,
                                      padding: EdgeInsets.only(
                                        bottom: Dimensions.height15 / 2,
                                        left: Dimensions.width10,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BetweenSM(
                                            color: kTextLightColor,
                                            text: '必填: ${Stringlist}',
                                            maxLines: 500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ////addCheckName 複選
                              if (StringList != '')
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: Dimensions.height15 * 2,
                                      height: Dimensions.height15 * 2,
                                      padding: EdgeInsets.only(
                                        bottom: Dimensions.height15 / 2,
                                        left: Dimensions.width10,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BetweenSM(
                                            color: kTextLightColor,
                                            text: '可選: ${StringList}',
                                            maxLines: 500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ////備註
                              if (cartController.cartlist[index].text != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: Dimensions.height15 * 2,
                                      height: Dimensions.height15 * 2,
                                      padding: EdgeInsets.only(
                                        bottom: Dimensions.height15 / 2,
                                        left: Dimensions.width10,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BetweenSM(
                                            color: kTextLightColor,
                                            text:
                                                '備註: ${cartController.cartlist[index].text}',
                                            maxLines: 500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              child: Row(
                children: [
                  Text(
                    '小計',
                    style: TextStyle(fontSize: Dimensions.fontsize18),
                  ),
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  Text(
                    UserSimplePreferences.getFinalPrice() == null
                        ? ''
                        : '${cartController.totalprice()}',
                    style: TextStyle(
                      color: kBodyTextColor,
                      fontSize: Dimensions.fontsize18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              child: Row(
                children: [
                  Text(
                    '折扣',
                    style: TextStyle(
                        color: kBodyTextColor, fontSize: Dimensions.fontsize18),
                  ),
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  Text(
                    UserSimplePreferences.getFinalPrice() == 0
                        ? '\$ 0'
                        : '\$ ${UserSimplePreferences.getFinalPrice()! - cartController.totalprice()}',
                    style: TextStyle(
                        color: kBodyTextColor, fontSize: Dimensions.fontsize18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationSetting {
  String title, cash;
  bool value;

  NotificationSetting(
      {required this.title, this.value = false, required this.cash});
}
