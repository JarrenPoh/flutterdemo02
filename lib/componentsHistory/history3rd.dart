import 'package:flutter/material.dart';

import '../models/BetweenSM.dart';
import '../models/ColorSettings.dart';
import '../models/MiddleText.dart';
import '../models/TabsText.dart';

class history3rd extends StatelessWidget {
  history3rd({
    Key? key,
    required this.finalprice,
    required this.totalprice,
  }) : super(key: key);
  int finalprice;
  int totalprice;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      child: Column(
        children: [
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
              )),
              TabText(
                color: kBodyTextColor,
                text: '\$ $totalprice',
                fontFamily: 'NotoSansRegular',
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
              )),
              TabText(
                color: kMaimColor,
                text: '\$ ${totalprice - finalprice}',
                fontFamily: 'NotoSansRegular',
              ),
            ],
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          Row(
            children: [
              MiddleText(
                color: kBodyTextColor,
                text: '總計',
                fontFamily: 'NotoSansBold',
              ),
              Expanded(
                  child: Column(
                children: const [],
              )),
              BetweenSM(
                color: kBodyTextColor,
                text: '\$ $finalprice',
                fontFamily: 'NotoSansRegular',
              ),
            ],
          ),
          SizedBox(
            height: Dimensions.height10,
          ),
        ],
      ),
    );
  }
}
