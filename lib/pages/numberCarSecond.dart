import 'dart:convert';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:flutterdemo02/API/shopCarApi.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../API/historyModel.dart';
import '../componentsHistory/history21st.dart';
import '../componentsHistory/history2nd.dart';
import '../componentsHistory/history3rd.dart';
import '../models/BigText.dart';
import '../models/ColorSettings.dart';
import 'package:flutterdemo02/provider/globals.dart' as globals;

import '../models/MiddleText.dart';
import '../provider/local_notification_service.dart';

class numberCardSecond extends StatefulWidget {
  numberCardSecond({
    Key? key,
    required this.arguments,
  }) : super(key: globals.globalToNumCard2);
  Map? arguments;
  @override
  State<numberCardSecond> createState() =>
      numberCardSecondState(arguments: arguments);
}

class numberCardSecondState extends State<numberCardSecond> {
  numberCardSecondState({required this.arguments});
  Map? arguments;
  final List _icons = [
    Icons.menu_book_outlined,
    Icons.restaurant_menu_outlined,
    Icons.restaurant
  ];

  var _curStep = 0;
  List<Widget> _iconViews() {
    var list = <Widget>[];

    _icons.asMap().forEach((i, icon) {
      //colors according to state
      var circleColor = (_curStep >= i + 1) ? kMaim3Color : Colors.grey[100];

      var lineColor = _curStep >= i + 2 ? kMaim3Color : Colors.grey[100];

      var iconColor = (_curStep >= i + 1) ? Colors.grey[100] : kMaim3Color;

      list.add(
        //dot with icon view
        Container(
          width: Dimensions.width15 * 3,
          height: Dimensions.height15 * 3,
          padding: EdgeInsets.all(0),
          child: Icon(
            icon,
            color: iconColor,
            size: Dimensions.icon25,
          ),
          decoration: new BoxDecoration(
            color: circleColor,
            borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
            border: new Border.all(
              color: kMaim3Color,
              width: 2.0,
            ),
          ),
        ),
      );

      //line between icons
      if (i != _icons.length - 1) {
        list.add(Expanded(
            child: Container(
          height: 2,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    List<String> _titles = [
      _curStep == 1 ? "餐點審核" : "審核通過",
      "備餐中..",
      "完成備餐",
    ];
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      var textColor = (_curStep >= i + 1) ? kTextLightColor : Colors.grey[300];
      list.add(
        TabText(
          color: textColor,
          text: text,
          fontFamily: 'NotoSansMedium',
        ),
      );
    });
    return list;
  }

  void refreshInformation() {
    if (data2 != null) {
      //

//
      if (accept == true && finish == null) {
        _curStep = 2; //接受餐點
      } else if (accept == true && finish == true) {
        _curStep = 3; //完成餐點
      } else if (accept == null) {
        _curStep = 1; //尚未接受餐點
      }
//
    }
    setState(() {
      print('setState finished in numCard2.dart');
      print('_curStep is $_curStep');
      print('$finish');
      print('$accept}');
      print('$comments}');
    });
  }

  void inspect() async {
    var ss = await shopCarApi.getCar(UserSimplePreferences.getToken());
    if (ss == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      shopCarApi.getCar(UserSimplePreferences.getToken());
    }
    inspect2();
  }

////
  String? comments;
  bool delete = false;
  bool? accept;
  bool? finish;
  Future inspect2() async {
    data2 = await historyApi(UserSimplePreferences.getToken());
    if (data2 == null) {
      String? refresh_token = await UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      data2 = await historyApi(UserSimplePreferences.getToken());
    }
    order = jsonDecode(data2!.order!);
    for (var i = 0; i < order!.length; i++) {
      int inin = order![i]['price'];
      totalprice += inin;
      print('totalprice1 is $totalprice');
    }
    shopname = data2!.storeInfo!.name;
    address = data2!.storeInfo!.address;
    numbering = data2!.sId;
    sequence = data2!.sequence;
    finalprice = data2!.total;
    reservation = data2!.reservation;
    SId = data2!.sId!;
    finish = data2!.finish;
    accept = data2!.accept;
    comments = data2!.comments;
    refreshInformation();
    oneSignalInit();
  }

////
  ///
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

  Result2? data2;
  List? order;
  List options = [];
  String optionsString = '';
  int totalprice = 0;
  String? shopname, address, numbering, reservation;
  int? sequence, finalprice;
  String SId = '';

  final cartController = Get.put(CartController());

  late final LocalNotificationService service;

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(payload) {
    if (payload != null) {
      Navigator.pushNamed(context, '/form3');
    }
  }

  void oneSignalInit() {
    // globals.appNavigator = GlobalKey<NavigatorState>();
    // globals.globalToNumCard2 = GlobalKey<numberCardSecondState>();

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) async {
        event.complete(event.notification);
        print('FOREGROUND HANDLER CALLED WITH: ${event}');
        //  /// Display Notification, send null to not display
        print('看這這這這看這這這這看這這這這看這這這這${event.notification.title}');
        print('看這這這這看這這這這看這這這這看這這這這${event.notification.body}');
        print('看這這這這看這這這這看這這這這看這這這這${event.notification.subtitle}');

        await globals.globalToNumCard2?.currentState?.inspect2();
        print('start numCard2 inspect2 is successful');

        int? finalSecond;
        if (reservation != null) {
          int selectHour =
              int.parse(reservation!.substring(0, 2));
          int selectMinute =
              int.parse(reservation!.substring(3, 5));
          print('selectHour ia $selectHour');
          print('selectMinute ia $selectMinute');
          int hour = TimeOfDay.now().hour;
          int minute = TimeOfDay.now().minute;

          finalSecond =
              ((selectHour * 60 + selectMinute) - (hour * 60 + minute)) * 60;
          print('finalSecond ia $finalSecond');
        }
        await service.showScheduledNotification(
          id: 0,
          title: '時間快到囉',
          body: '您預定的取餐時間"${reservation}"快到了，請留意餐點進度',
          seconds: finalSecond!,
        );
      },
    );
  }

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    data2 = arguments?['data2'];
    // oneSignalInit();
    if (data2 != null) {
      order = jsonDecode(data2!.order!);
      for (var i = 0; i < order!.length; i++) {
        int inin = order![i]['price'];
        totalprice += inin;
        print('totalprice1 is $totalprice');
      }

      shopname = arguments?['shopname'];
      address = arguments?['address'];
      numbering = arguments?['numbering'];
      sequence = arguments?['sequence'];
      finalprice = arguments?['finalprice'];
      reservation = arguments?['reservation'];
      SId = arguments?['SId'];
      finish = arguments?['finish'];
      accept = arguments?['accept'];
      comments = arguments?['comments'];
      refreshInformation();
    }

    if (data2 == null) {
      inspect();
    }

    // TODO: implement initState
    super.initState();
  }

  historyApi(key) async {
    var response = await http.get(
        Uri.parse(
            'https://hello-cycu-delivery-service.herokuapp.com/member/user/order'),
        headers: {
          "token": '$key',
          "Content-Type": "application/x-www-form-urlencoded"
        });

    debugPrint('statusCode in numCard2 is ${response.statusCode}');
    if (response.statusCode == 200) {
      debugPrint('responsebody${response.body}');
      var obj = Autogenerated2.fromJson(jsonDecode(response.body));

      var myaddress = (obj.result as List<Result2?>);
      return myaddress.last;
    } else if (response.statusCode == 403) {
      debugPrint('status${response.statusCode}');
      return null;
    } else {
      throw Exception('Failed to load store');
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
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 5,
                title: BetweenSM(
                  color: kBodyTextColor,
                  text: '訂單詳情',
                  fontFamily: 'NotoSansMedium',
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.west,
                    color: kMaimColor,
                    size: Dimensions.icon25,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/form3');
                    cartController.deleteAll();
                  },
                ),
              ),
              body: order == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    )
                  : SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height15 * 3,
                          left: Dimensions.width10 * 2,
                          right: Dimensions.width10 * 2,
                        ),
                        width: Dimensions.screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                left: Dimensions.width10 * 1,
                                right: Dimensions.width10 * 1,
                              ),
                              child: Row(
                                children: _iconViews(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _titleViews(),
                            ),
                            ////////////
                            Column(
                              children: [
                                SizedBox(height: Dimensions.height15 * 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SmallText(
                                      color: kTextLightColor,
                                      text: '我想請求撤單  ->',
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
                                        primary: Colors.white,
                                      ),
                                      child: SId != ''
                                          ? TabText(
                                              text: '撤單',
                                              color: kMaim3Color,
                                              fontFamily: 'NotoSansMedium',
                                            )
                                          : Container(
                                              width: Dimensions.fontsize24 / 2,
                                              height: Dimensions.fontsize24 / 2,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: Dimensions.height15 * 1),
                                if (comments != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SmallText(
                                        color: kTextLightColor,
                                        text: '店家給你留言  ->',
                                        fontFamily: 'NotoSansMedium',
                                      ),
                                      SizedBox(
                                        width: Dimensions.width10,
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: TabText(
                                                    color: kTextLightColor,
                                                    text: '查看留言',
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
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          child: TabText(
                                            text: '店家有話跟你說',
                                            color: kMaim3Color,
                                            fontFamily: 'NotoSansMedium',
                                          )),
                                    ],
                                  ),
                                SizedBox(height: Dimensions.height15 * 1),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BetweenSM(
                                  color: kBodyTextColor,
                                  text: '訂單詳情',
                                  fontFamily: 'NotoSansMedium',
                                ),
                                SizedBox(height: Dimensions.height15),
                                history1st(
                                  shopname: shopname!,
                                  address: address!,
                                  numbering: numbering!,
                                  sequence: sequence!,
                                  reservation: reservation,
                                ),
                                const Divider(),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height10),
                                  child: Column(
                                    children: List.generate(
                                      order!.length,
                                      (index) {
                                        return history2nd(
                                            describes: order![index]['note'],
                                            name: order![index]['name'],
                                            price: order![index]['price'],
                                            options: jsonDecode(
                                                order![index]['options']),
                                            counts: order![index]['count']);
                                      },
                                    ),
                                  ),
                                ),
                                const Divider(),
                                history3rd(
                                  totalprice: totalprice,
                                  finalprice: finalprice!,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // void oneSignalInit() {
  //   globals.appNavigator = GlobalKey<NavigatorState>();
  //   globals.globalToNumCard2 = GlobalKey<numberCardSecondState>();
  //   OneSignal.shared.setNotificationOpenedHandler((openedResult) {
  //     print('openedResult.action!.type; is ${openedResult.action!.type}');

  //     globals.globalToNumCard2?.currentState?.inspect2();
  //     print('start numCard2 inspect2 is successful');

  //     globals.appNavigator?.currentState?.push(
  //       MaterialPageRoute(
  //         builder: (context) => numberCardSecond(
  //           arguments: {},
  //         ),
  //       ),
  //     );
  //     print('navigator to orderCard2 is successful');
  //   });

  //   OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //     (OSNotificationReceivedEvent event) async {
  //       event.complete(event.notification);
  //       print('FOREGROUND HANDLER CALLED WITH: ${event}');
  //       //  /// Display Notification, send null to not display
  //       print('看這這這這看這這這這看這這這這看這這這這${event.notification.title}');
  //       print('看這這這這看這這這這看這這這這看這這這這${event.notification.body}');
  //       print('看這這這這看這這這這看這這這這看這這這這${event.notification.subtitle}');
  //       // listenToNotification();
  //       // await service.showNotificationWithPayload(
  //       //   id: 0,
  //       //   title: event.notification.title,
  //       //   body: event.notification.body,
  //       //   payload: '',
  //       // );
  //       await globals.globalToNumCard2?.currentState?.inspect2();
  //       print('看這這這這看這這這這看這這這這看這這這這${event.notification.subtitle}');
  //     },
  //   );
  // }
}
