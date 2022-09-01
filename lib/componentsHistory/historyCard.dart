import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import '../API/historyModel.dart';
import '../models/ColorSettings.dart';
import '../models/SmallText.dart';

class historyCard extends StatefulWidget {
  historyCard({
    Key? key,
    required this.Data,
  }) : super(key: key);
  Result2 Data;

  @override
  State<historyCard> createState() => _historyCardState(
        Data: Data,
      );
}

class _historyCardState extends State<historyCard> {
  Result2 Data;

  _historyCardState({
    required this.Data,
  });
  List DataList = [];
  String totalNames() {
    String total = '';

    for (var i = 0; i < DataList.length; i++) {
      total += '${DataList[i]['name']}';
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: Dimensions.screenWidth / 130.66),
      height: Dimensions.screenHeigt / 4.4,
      width: Dimensions.screenWidth,
      child: Column(
        children: [
          SizedBox(
            height: Dimensions.height15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/history2', arguments: {
                'shopname': Data.storeInfo!.name,
                'address': Data.storeInfo!.address,
                'image': Data.image,
                'discount': Data.discount,
                'finalprice': Data.total,
                'Data': Data,
                'numbering': Data.sId,
                'order': jsonDecode(Data.order!),
                // 'orderSet':orderSet,
              });
            },
            child: Card(
              elevation: Dimensions.height5,
              shadowColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius5),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                      vertical: Dimensions.height15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(right: Dimensions.width15),
                              height: Dimensions.screenHeigt / 10.31,
                              width: Dimensions.screenHeigt / 10.31,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius10),
                                child: Column(
                                  children: [
                                    if (Data.image != null)
                                      AspectRatio(
                                        aspectRatio: 10 / 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radius15,
                                          ),
                                          child: Image.asset(
                                            Data.image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    if (Data.image == null)
                                      AspectRatio(
                                        aspectRatio: 10 / 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius15),
                                          child: Container(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Dimensions.screenHeigt / 13.75,
                                      width: Dimensions.screenWidth / 2.15,
                                      child: BetweenSM(
                                        color: kBodyTextColor,
                                        text: Data.storeInfo!.name!,
                                        maxLines: 2,
                                        fontFamily: 'NotoSansMedium',
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimensions.width20,
                                    ),
                                    SizedBox(
                                      width: Dimensions.screenWidth / 7.84,
                                      height: Dimensions.screenHeigt / 13.66,
                                      child: BetweenSM(
                                          color: kBodyTextColor,
                                          text: '\$ ${Data.total}',
                                          maxLines: 2,
                                          fontFamily: 'NotoSansMedium'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      Dimensions.height20 + Dimensions.height5,
                                  width: Dimensions.screenWidth / 1.55,
                                  child: TabText(
                                    color: kBodyTextColor,
                                    text: totalNames(),
                                    fontFamily: ' NotoSansRegular',
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: Dimensions.height15),
                              child: SmallText(
                                color: kTextLightColor,
                                text: Data.dATE!.substring(0, 10),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.56,
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Container(
                                    height: Dimensions.screenHeigt / 26.45,
                                    width: Dimensions.screenWidth / 4.35,
                                    margin: EdgeInsets.only(
                                        top: Dimensions.height15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius5),
                                      color: kMaimColor,
                                    ),
                                    child: TabText(
                                      color: Colors.white,
                                      text: '前往店家',
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
