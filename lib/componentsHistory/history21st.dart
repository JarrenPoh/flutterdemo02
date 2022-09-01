import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

import '../models/TabsText.dart';

class history1st extends StatelessWidget {
  history1st(
      {Key? key,
      required this.shopname,
      required this.numbering,
      required this.address})
      : super(key: key);
  final String numbering, address, shopname;
  String subNum = '';
  String subnumbering() {
    print(numbering);
    subNum = numbering.substring(0, 8);
    print(subNum);
    subNum += numbering.substring(numbering.length - 6, numbering.length);
    print('${numbering.substring(numbering.length - 6, numbering.length)}');
    return subNum;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabText(color: kTextLightColor, text: '訂單編號'),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TabText(
                      color: kBodyTextColor,
                      text: subnumbering(),
                      maxLines: 1,
                      fontFamily: 'NotoSansMedium',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabText(color: kTextLightColor, text: '訂購於'),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      width: 180,
                      child: TabText(
                        color: kMaimColor,
                        text: shopname,
                        maxLines: 10,
                        textAlign: TextAlign.end,
                        fontFamily: 'NotoSansMedium',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabText(color: kTextLightColor, text: '店家位址'),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      width: 180,
                      child: TabText(
                        color: kBodyTextColor,
                        text: address,
                        maxLines: 10,
                        textAlign: TextAlign.end,
                        fontFamily: 'NotoSansMedium',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}