import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import '../API/historyModel.dart';
import '../componentsHistory/history21st.dart';
import '../componentsHistory/history2nd.dart';
import '../componentsHistory/history3rd.dart';
import '../models/BigText.dart';
import '../models/ColorSettings.dart';

class numberCardSecond extends StatefulWidget {
  numberCardSecond({
    Key? key,
    required this.arguments,
  }) : super(key: key);
  Map arguments;
  @override
  State<numberCardSecond> createState() =>
      _numberCardSecondState(arguments: arguments);
}

class _numberCardSecondState extends State<numberCardSecond> {
  _numberCardSecondState({required this.arguments});
  Map arguments;
  List _icons = [
    Icons.menu_book_outlined,
    Icons.restaurant_menu_outlined,
    Icons.restaurant
  ];
  List<String> _titles = [
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

  Result2? data2;
  List order = [];
  List options = [];
  String optionsString = '';
  int totalprice = 0;
  @override
  void initState() {
    data2 = arguments['data2'];
    order = jsonDecode(data2!.order!);
    for (var i = 0; i < order.length; i++) {
      int inin = order[i]['price'];
      totalprice += inin;
      print('totalprice1 is $totalprice');
    }
    // TODO: implement initState
    super.initState();
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SingleChildScrollView(
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
                      SizedBox(height: 10),
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
                            shopname: arguments['shopname'],
                            address: arguments['address'],
                            numbering: arguments['numbering'],
                            sequence:arguments['sequence'],
                          ),
                          const Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height10),
                            child: Column(
                              children: List.generate(
                                order.length,
                                (index) {
                                  return history2nd(
                                      describes: order[index]['note'],
                                      name: order[index]['name'],
                                      price: order[index]['price'],
                                      options:
                                          jsonDecode(order[index]['options']),
                                      counts: order[index]['count']);
                                },
                              ),
                            ),
                          ),
                          const Divider(),
                          history3rd(
                            totalprice: totalprice,
                            finalprice: arguments['finalprice'],
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
