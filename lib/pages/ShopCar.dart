import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/shopCarApi.dart';
import 'package:flutterdemo02/componentsShopcar/contactWay.dart';
import 'package:flutterdemo02/componentsShopcar/shopOrders.dart';
import 'package:flutterdemo02/componentsShopcar/total.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:get/get.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../API/shopCarModel.dart';
import '../componentsShopcar/reservation.dart';
import '../componentsShopcar/shopcarAppBar.dart';
import '../controllers/cart_controller.dart';
import '../models/BetweenSM.dart';
import 'package:http/http.dart' as http;

import '../provider/Shared_Preference.dart';

class shopCar extends StatefulWidget {
  shopCar({Key? key, required this.arguments}) : super(key: key);
  Map arguments;
  @override
  State<shopCar> createState() => _shopCarState(arguments: arguments);
}

class _shopCarState extends State<shopCar> {
  Map arguments;
  _shopCarState({required this.arguments});

  final CartController cartController = Get.find();
  late Result ss =
      Result.fromJson(jsonDecode(UserSimplePreferences.getOrderPreview()!));
  int finalprice = 0;
  ////////////
  Future inspect() async {
    var shopcar = await spectator(UserSimplePreferences.getToken());
    if (shopcar == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      ss = await spectator(UserSimplePreferences.getToken());
    } else if (shopcar != null) {
      ss = shopcar;
    }
    return ss;
  }

  spectator(key) async {
    var response = await http.post(
      Uri.parse(
          "https://hello-cycu-delivery-service.herokuapp.com/member/user/order/preview"),
      headers: {
        "token": key,
        "Content-Type": "application/json",
      },
      body: cartController.options(),
    );
    // debugPrint(
    //     'cartController.options in ShopCar.dart is ${cartController.options()}');
    debugPrint('statuscode in ShopCar.dart is ${response.statusCode}');
    debugPrint('statusbody in ShopCar.dart is ${response.body}');
    if (response.statusCode == 201) {
      print('response.body is ${response.body}');
      var obj = Autogenerated.fromJson(jsonDecode(response.body));
      var myaddress = (obj.result as Result);
      finalprice = myaddress.total!;
      debugPrint('statuscode is ${response.statusCode}');
      return await myaddress;
    } else if (response.statusCode == 403) {
      debugPrint('statuscode is ${response.statusCode}');
      return await null;
    } else {
      throw Exception('Failed to load store');
    }
  }

  List order = [];
  StoreInfo? storeInfo;
  int finalPrice = 0;
  bool tableWare = false;
  String? reservation;
  bool selectTime = false;
  ////////////
  refresh() {
    print('cartController.ifUpdateCar is ${cartController.ifUpdateCar}');
    if (cartController.ifUpdateCar == true) {
      UserSimplePreferences.setFinalPrice(0);
      inspect().then(
        (value) {
          if (ss != null) {
            UserSimplePreferences.setOrderPreview(jsonEncode(ss));
            UserSimplePreferences.setFinalPrice(ss.total!);
            if (mounted) {
              setState(() {});
            }
          }
        },
      );
      cartController.ifUpdate(name: false);
    }
  }

  @override
  void initState() {
    refresh();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, //ios icon white
        statusBarIconBrightness: Brightness.light, //android icon white
        // statusBarColor: Colors.red  //android backgroungColor
      ),
      child: Scaffold(
        body: Container(
          color: kMaim3Color,
          child: SafeArea(
            child: Scaffold(
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.height15),
                        child: GestureDetector(
                          onTap: () async {
                            print(
                                'UserSimplePreferences.getFinalPrice() is ${UserSimplePreferences.getFinalPrice()}');
                            if (UserSimplePreferences.getFinalPrice() != 0) {
                              print('selectTime == $selectTime 代表可以打開');
                              if (selectTime == true) {
                                bool? delete = await showDeleteDialod();
                                //發送訂單
                                if (delete == false) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/ordersuccessful', (route) => false);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TabText(
                                          color: kBodyTextColor,
                                          text: "請選擇取餐時間",
                                          fontFamily: 'NotoSansMedium',
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('確定'),
                                      ),
                                    ],
                                    title: BetweenSM(
                                      text: "尚未填選",
                                      color: kBodyTextColor,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Card(
                            borderOnForeground: false,
                            color: kMaimColor,
                            child: Container(
                              height: Dimensions.height50,
                              child: Center(
                                child: BetweenSM(
                                  color: Colors.white,
                                  text: '前往確認餐點',
                                  fontFamily: 'NotoSansMedium',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              appBar: shopcarAppBar(),
              body: Container(
                color: Colors.white,
                child: ListView(
                  children: [
                    const contactWay(),
                    Divider(
                      thickness: Dimensions.height10,
                      color: kBottomColor,
                    ),
                    shopOrders(notifyParent: refresh),
                    Divider(
                      thickness: Dimensions.height10,
                      color: kBottomColor,
                    ),
                    Reservation(
                      notifyParent: refresh,
                      businessTime: arguments['businessTime'],
                      selectTime: selectTime,
                      BoolCallBack: (value) {
                        setState(() {
                          selectTime = value;
                        });
                      },
                    ),
                    Divider(
                      thickness: Dimensions.height10,
                      color: kBottomColor,
                    ),
                    total(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showDeleteDialod() {
    int totalprice = 0;
    ss = Result.fromJson(jsonDecode(UserSimplePreferences.getOrderPreview()!));
    order = jsonDecode(ss.order!);
    storeInfo = ss.storeInfo;
    finalPrice = ss.total!;
    tableWare = ss.tableware!;
    reservation = ss.reservation;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kBottomColor,
          scrollable: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BetweenSM(
                color: kBodyTextColor,
                text: '請檢查您的餐點，點擊確認送出後無法還原',
                fontFamily: 'NotoSansMedium',
                maxLines: 3,
              ),
              Divider(),
              BetweenSM(
                color: kTextLightColor,
                text: storeInfo!.name!,
                fontFamily: 'NotoSansMedium',
                maxLines: 10,
              ),
              BetweenSM(
                color: kTextLightColor,
                text: storeInfo!.address!,
                fontFamily: 'NotoSansMedium',
                maxLines: 10,
              ),
            ],
          ),
          content: Column(
            children: [
              Column(
                children: List.generate(
                  order.length,
                  (index) {
                    var str = jsonDecode(order[index]['options']);
                    List options = str;
                    print('options is $options');

                    ///小計
                    totalprice = 0;
                    for (var i = 0; i < order.length; i++) {
                      int inin = order[i]['price'];
                      totalprice += inin;
                    }
                    ///////
                    ///檢查options裡面是list是string，都變成string
                    List optionsList = [];
                    for (var i = 0; i < options.length; i++) {
                      if (options[i]['option'].runtimeType == List) {
                        List fdfd = options[i]['option'];
                        String fsfdd = fdfd.join(',');
                        optionsList.add(fsfdd);
                      } else if (options[i]['option'].runtimeType == String) {
                        optionsList.add(options[i]['option']);
                      }
                    }
                    String optionsString = optionsList.join(',');
                    print('optionsString is ${optionsString}');
                    ///////
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TabText(
                                    color: kBodyTextColor,
                                    text: order[index]['name'],
                                    fontFamily: 'NotoSansMedium',
                                    maxLines: 10,
                                  ),
                                  TabText(
                                    color: kTextLightColor,
                                    text: ' 選擇: $optionsString',
                                    fontFamily: 'NotoSansMedium',
                                    maxLines: 300000,
                                  ),
                                  TabText(
                                    color: kTextLightColor,
                                    text: order[index]['note'] == '無備註'
                                        ? ''
                                        : ' 備註: ${order[index]['note']}',
                                    fontFamily: 'NotoSansMedium',
                                    maxLines: 300000,
                                  ),
                                ],
                              ),
                            ),
                            TabText(
                              color: kBodyTextColor,
                              text: '\$ ${order[index]['price']}',
                              fontFamily: 'NotoSansMedium',
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  TabText(
                    color: kBodyTextColor,
                    text: '免洗餐具',
                    fontFamily: 'NotoSansMedium',
                  ),
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  TabText(
                    color: kBodyTextColor,
                    text: cartController.tableware == true ? '需要' : '不需要',
                    fontFamily: 'NotoSansMedium',
                  ),
                ],
              ),
              Row(
                children: [
                  TabText(
                    color: kMaimColor,
                    text: '* ',
                    fontFamily: 'NotoSansMedium',
                  ),
                  TabText(
                    color: kBodyTextColor,
                    text: '取餐時間',
                    fontFamily: 'NotoSansMedium',
                  ),
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  TabText(
                    color: kMaimColor,
                    text: reservation ?? '即時',
                    fontFamily: 'NotoSansMedium',
                  ),
                  SmallText(
                    color: kTextLightColor,
                    text: reservation != null ? '(10分鐘)' : '',
                    fontFamily: 'NotoSansMedium',
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              Row(
                children: [
                  TabText(
                    color: kBodyTextColor,
                    text: '小計',
                    fontFamily: 'NotoSansMedium',
                  ),
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  TabText(
                    color: kBodyTextColor,
                    text: '\$ $totalprice',
                    fontFamily: 'NotoSansMedium',
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              Row(
                children: [
                  TabText(
                    color: kBodyTextColor,
                    text: '折扣',
                    fontFamily: 'NotoSansMedium',
                  ),
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  TabText(
                    color: kBodyTextColor,
                    text:
                        '\$ ${UserSimplePreferences.getFinalPrice()! - totalprice}',
                    fontFamily: 'NotoSansMedium',
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
              Row(
                children: [
                  TabText(
                    color: kBodyTextColor,
                    text: '總計',
                    fontFamily: 'NotoSansBold',
                  ),
                  Expanded(
                    child: Column(
                      children: const [],
                    ),
                  ),
                  TabText(
                    color: kMaimColor,
                    text: '\$ ${UserSimplePreferences.getFinalPrice()}',
                    fontFamily: 'NotoSansBold',
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '回去再看看',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Card(
              borderOnForeground: false,
              color: kMaimColor,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  '送出訂單',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
