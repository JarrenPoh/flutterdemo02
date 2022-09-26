import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/models/BigText.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:flutterdemo02/API/shopCarApi.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../API/historyModel.dart';
import '../API/shopCarModel.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../models/BetweenSM.dart';
import 'package:http/http.dart' as http;

import '../provider/local_notification_service.dart';

class orderSuccessful extends StatefulWidget {
  orderSuccessful({Key? key}) : super(key: key);

  @override
  State<orderSuccessful> createState() => _orderSuccessfulState();
}

class _orderSuccessfulState extends State<orderSuccessful> {
  late Future<Result?>? order;
  final cartController = Get.put(CartController());
  void inspect() async {
    var ss = await spectator();
    if (ss == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      order = shopCarApi.getCar(UserSimplePreferences.getToken());
    }
    inspect2();
  }

  Future spectator() async {
    order = shopCarApi.getCar(UserSimplePreferences.getToken());
    return await order;
  }

  late final LocalNotificationService service;

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(payload) {
    if (payload != null) {
      Navigator.pushNamed(context, '/form3');
    }
  }

  @override
  void initState() {
    inspect();
    startTimer();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  ////申請店家回應
  bool isLoading = false;
  bool bottonloading = false;
  bool deal = false;
  bool haveComments = false;
  String? comments = '';
  List<Result2?>? accept;
  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  String SId = '';
  void inspect2() async {
    accept = await historyApi(UserSimplePreferences.getToken());
    if (accept == null) {
      String? refresh_token = await UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      accept = await historyApi(UserSimplePreferences.getToken());
    }

    if (accept?.last?.comments != '') {
      haveComments = true;
      comments = accept!.last!.comments;
    } else {
      haveComments = false;
    }
//
    if (accept!.last!.accept == true && accept!.last!.complete == false) {
      int? finalSecond;
      if (accept!.last!.reservation != null) {
        int selectHour = int.parse(accept!.last!.reservation!.substring(0, 2));
        int selectMinute =
            int.parse(accept!.last!.reservation!.substring(3, 5));
        print('selectHour ia $selectHour');
        print('selectMinute ia $selectMinute');
        int hour = TimeOfDay.now().hour;
        int minute = TimeOfDay.now().minute;

        finalSecond =
            ((selectHour * 60 + selectMinute) - (hour * 60 + minute)) * 60;
        print('finalSecond ia $finalSecond');
      }

      deal = true;
      await service.showNotificationWithPayload(
        id: 0,
        title: '訂單成立(${accept!.last!.storeInfo!.name})',
        body: '您的取餐時間為${'"${accept!.last!.reservation ?? '即時'}"'}'
            '${comments != null ? ' ，店家留言給你"$comments"' : ''}',
        payload: '',
      );
      if (finalSecond != null) {
        await service.showScheduledNotification(
          id: 0,
          title: '時間快到囉',
          body: '您預定的取餐時間"${accept!.last!.reservation}"快到了，請留意餐點進度',
          seconds: finalSecond,
        );
      }
    } else if (accept!.last!.accept == false &&
        accept!.last!.complete == true &&
        delete == false) {
      deal = false;
      service.showNotificationWithPayload(
        id: 0,
        title: '訂單不成立',
        body: '店家拒絕了你的訂單' '${comments != null ? ' ，店家留言給你"$comments"' : ''}',
        payload: '',
      );
    } else {
      accept = null;
    }
  }

  historyApi(key) async {
    var response = await http.get(
        Uri.parse(
            'https://hello-cycu-delivery-service.herokuapp.com/member/user/order'),
        headers: {
          "token": '$key',
          "Content-Type": "application/x-www-form-urlencoded"
        });

    if (response.statusCode == 200) {
      debugPrint('status${response.statusCode}');
      debugPrint('responsebody${response.body}');
      var obj = Autogenerated2.fromJson(jsonDecode(response.body));

      var myaddress = (obj.result as List<Result2?>);
      SId = myaddress.last!.sId!;
      setState(() {});
      return myaddress;
    } else if (response.statusCode == 403) {
      debugPrint('status${response.statusCode}');
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds == 0) {
        seconds = maxSeconds;
        if (accept == null) {
          inspect2();
        }
      } else {
        seconds--;
      }

      print(seconds);
    });
  }

  ////////////
  bool delete = false;
  Future inspect3() async {
    var ss = await deleteOrder(UserSimplePreferences.getToken());
    if (ss == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      ss = await deleteOrder(UserSimplePreferences.getToken());
    }
    print('ss is $ss');
    if (ss['status'] == '訂單已成功撤回') {
      var Text = ss['result'];
      var Status = ss['status'];
      setState(() {
        delete = true;
        Get.snackbar(
          "$Status",
          "$Text",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      });
    } else {
      setState(() {
        var Text = ss['result'];
        var Status = ss['status'];
        Get.snackbar(
          "$Status",
          "$Text",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      });
    }
  }

  deleteOrder(key) async {
    print('SId SId is $SId');
    var response = await http.delete(
        Uri.parse(
            'https://hello-cycu-delivery-service.herokuapp.com/member/user/order'),
        headers: {
          "token": key,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "orderid": SId
        });

    debugPrint(
        'response statusCode in order_successful.dart is ${response.statusCode}');
    var obj = (jsonDecode(response.body));

    debugPrint('obj is ${obj}');

    if (response.statusCode == 200) {
      return obj;
    } else if (response.statusCode == 403) {
      return null;
    } else {
      return obj;
    }
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
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  accept == null
                      ? delete == false
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(child: CircularProgressIndicator()),
                                Positioned(
                                  top: Dimensions.height50,
                                  left: Dimensions.width20,
                                  child: BetweenSM(
                                    color: kBodyTextColor,
                                    text: '正在等待店家回應..',
                                    fontFamily: 'NotoSansBold',
                                  ),
                                ),
                                Positioned(
                                  bottom: Dimensions.height50,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          BetweenSM(
                                            color: kTextLightColor,
                                            text: '不想吃了?我想撤單  ->',
                                            fontFamily: 'NotoSansMedium',
                                          ),
                                          SizedBox(
                                            width: Dimensions.width10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (SId != '') {
                                                await inspect3();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: kMaim3Color,
                                            ),
                                            child: SId != ''
                                                ? TabText(
                                                    text: '撤單',
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'NotoSansMedium',
                                                  )
                                                : Container(
                                                    width:
                                                        Dimensions.fontsize24 /
                                                            2,
                                                    height:
                                                        Dimensions.fontsize24 /
                                                            2,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height15 * 2,
                            horizontal: Dimensions.width10 * 2,
                          ),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  deal == true
                                      ? BigText(
                                          color: kTextLightColor,
                                          text: '老闆接單囉~',
                                          fontFamily: 'NotoSansBold',
                                        )
                                      : BigText(
                                          color: kTextLightColor,
                                          text: delete ? '已撤回訂單' : '訂單失敗囉~',
                                          fontFamily: 'NotoSansBold',
                                        )
                                ],
                              ),
                              Center(
                                child: Container(
                                  color: Colors.white,
                                  child: Image.asset(
                                    'images/foodone_logo_pink_1000.jpg',
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: Card(
                                      borderOnForeground: false,
                                      color: haveComments
                                          ? Colors.blue
                                          : Colors.grey,
                                      child: TextButton(
                                        onPressed: () async {
                                          if (haveComments == true) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: TabText(
                                                    color: kTextLightColor,
                                                    text: '店家有話跟你說~',
                                                    fontFamily:
                                                        'NotoSansMedium',
                                                  ),
                                                  content: MiddleText(
                                                    color: kBodyTextColor,
                                                    text: '$comments',
                                                    fontFamily:
                                                        'NotoSansMedium',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        haveComments = false;
                                                        setState(() {});
                                                      },
                                                      child: TabText(
                                                        color: Colors.blue,
                                                        text: '知道了',
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context, '/form3',(route) => false);
                                            cartController.deleteAll();
                                          }
                                        },
                                        child: Text(
                                          haveComments ? '店家有話跟你說' : '返回首頁',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
