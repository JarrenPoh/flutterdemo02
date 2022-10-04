import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:flutterdemo02/API/shopCarApi.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../API/historyModel.dart';
import '../componentsHistory/history21st.dart';
import '../componentsHistory/history2nd.dart';
import '../componentsHistory/history3rd.dart';
import '../models/BigText.dart';
import '../models/ColorSettings.dart';

class numberCardSecond extends StatefulWidget {
  numberCardSecond({
    Key? appNavigator,
    required this.arguments,
  }) : super(key: appNavigator);
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
  final List<String> _titles = [
    "餐點審核",
    "備餐中..",
    "完成備餐",
  ];

  var _curStep = 0;
  List<Widget> _iconViews() {
    var list = <Widget>[];

    _icons.asMap().forEach((i, icon) {
      //colors according to state
      var circleColor = (_curStep >= i + 1) ? kMaim3Color : Colors.grey[100];

      var lineColor = _curStep >= i + 1 ? kMaim3Color : Colors.grey[100];

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
  bool haveComments = false;
  String? comments = '';
  bool delete = false;
  void inspect2() async {
    data2 = await historyApi(UserSimplePreferences.getToken());
    if (data2 == null) {
      String? refresh_token = await UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      data2 = await historyApi(UserSimplePreferences.getToken());
    }

    if (data2?.comments != '') {
      haveComments = true;
      comments = data2!.comments;
    } else {
      haveComments = false;
    }

    if (data2 != null) {
      order = jsonDecode(data2!.order!);
      for (var i = 0; i < order!.length; i++) {
        int inin = order![i]['price'];
        totalprice += inin;
        print('totalprice1 is $totalprice');
      }
    }

    shopname = data2!.storeInfo!.name;
    address = data2!.storeInfo!.address;
    numbering = data2!.sId;
    sequence = data2!.sequence;
    finalprice = data2!.total;
    reservation =data2!.reservation;
    setState(() {});
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
  String? shopname, address, numbering,reservation;
  int? sequence, finalprice;
  String SId = '';

  @override
  void initState() {
    data2 = arguments?['data2'];

    if (data2 != null) {
      order = jsonDecode(data2!.order!);
      for (var i = 0; i < order!.length; i++) {
        int inin = order![i]['price'];
        totalprice += inin;
        print('totalprice1 is $totalprice');
      }
    }

    shopname = arguments?['shopname'];
    address = arguments?['address'];
    numbering = arguments?['numbering'];
    sequence = arguments?['sequence'];
    finalprice = arguments?['finalprice'];
    reservation = arguments?['reservation'];

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

    if (response.statusCode == 200) {
      debugPrint('status${response.statusCode}');
      debugPrint('responsebody${response.body}');
      var obj = Autogenerated2.fromJson(jsonDecode(response.body));

      var myaddress = (obj.result as List<Result2?>);
      SId = myaddress.last!.sId!;
      // setState(() {});
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
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/form3', (route) => false)),
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
                            SizedBox(height: Dimensions.height15 * 4),
                            ////////////
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
                                  reservation:reservation,
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
}
