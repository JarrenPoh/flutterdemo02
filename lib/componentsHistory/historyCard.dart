import 'dart:convert';

import 'package:flutter/material.dart';

import '../API/historyModel.dart';
import '../models/BetweenSM.dart';
import '../models/ColorSettings.dart';
import '../models/SmallText.dart';
import '../models/TabsText.dart';

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
    List order = jsonDecode(Data.order!);
    for (var i = 0; i < order.length; i++) {
      total += '${order[i]['name']}、';
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.screenWidth / 130.66,
      ),
      width: Dimensions.screenWidth,
      child: Column(
        children: [
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
                // 'id':店家id,

                // 'orderSet':orderSet,
              });
            },
            child: Card(
              elevation: Dimensions.height5,
              shadowColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height5,
                ),
                child: SizedBox(
                  height:
                      Dimensions.screenHeigt / 4.4 - Dimensions.height15 * 2,
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height10),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: Dimensions.width15,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radius10,
                                    ),
                                    child: Column(
                                      children: [
                                        if (Data.image != null)
                                          AspectRatio(
                                            aspectRatio: 10 / 10,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                              ),
                              Expanded(
                                flex: 7,
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Flex(
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 0,
                                            child: Column(
                                              children: [
                                                BetweenSM(
                                                  color: kBodyTextColor,
                                                  text:
                                                      '${Data.storeInfo!.name}',
                                                  maxLines: 2,
                                                  fontFamily: 'NotoSansMedium',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TabText(
                                                  color: kTextLightColor,
                                                  text:
                                                      '${totalNames()}',
                                                  fontFamily:
                                                      ' NotoSansRegular',
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width:Dimensions.width15,),
                                    Expanded(
                                      flex: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          BetweenSM(
                                            color: kBodyTextColor,
                                            text: '\$ ${Data.total}',
                                            maxLines: 2,
                                            fontFamily: 'NotoSansMedium',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height5,
                      ),
                      Expanded(
                        flex: 1,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.height15),
                                child: SmallText(
                                  color: kTextLightColor,
                                  text: Data.dATE!.substring(0, 10),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.height5 / 2),
                                height: Dimensions.screenHeigt / 26.45,
                                width: Dimensions.screenWidth / 4.35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.radius5),
                                  color: kMaimColor,
                                ),
                                child: TabText(
                                  color: Colors.white,
                                  text: '前往店家',
                                  fontFamily: 'NotoSansMedium',
                                ),
                              ),
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
        ],
      ),
    );
  }
}
