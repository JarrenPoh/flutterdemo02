import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../API/shopCarModel.dart';
import '../controllers/cart_controller.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../provider/Shared_Preference.dart';

class total extends StatefulWidget {
  total({
    Key? key,
  }) : super(key: key);

  @override
  State<total> createState() => _totalState();
}

class _totalState extends State<total> {
  bool state = false;
  final CartController cartController = Get.find();
  @override
  void initState() {
    super.initState();

    state = cartController.tableware;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
            child: Row(
              children: [
                Text(
                  '需要免洗餐具嗎',
                  style: TextStyle(fontSize: Dimensions.fontsize24),
                ),
                Expanded(
                  child: Column(
                    children: const [],
                  ),
                ),
                Switch(
                    activeColor: kMaimColor,
                    value: state,
                    onChanged: (bool s) {
                      setState(() {
                        state = s;
                        print('the tableware $state');
                        cartController.tableWare(tablewareBool: state);
                      });
                    })
              ],
            ),
          ),
          subtitle: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.width10, bottom: Dimensions.height10),
              child: BetweenSM(
                color: kTextLightColor,
                text: '不需要，我要愛護地球',
                fontFamily: 'NotoSansMedium',
              )),
        ),
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(
                left: Dimensions.width10,
                bottom: Dimensions.height10,
                right: Dimensions.width10),
            child: Row(
              children: [
                Text(
                  '總金額',
                  style: TextStyle(fontSize: Dimensions.fontsize24),
                ),
                Expanded(
                  child: Column(
                    children: const [],
                  ),
                ),
                Text(
                  '\$ ${UserSimplePreferences.getFinalPrice().toString()}',
                  style: const TextStyle(color: kBodyTextColor, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
