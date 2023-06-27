import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/pages/History2Order.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';

import '../API/historyModel.dart';
import '../models/BetweenSM.dart';
import '../models/ColorSettings.dart';
import '../models/SmallText.dart';
import '../models/TabsText.dart';

class historyCard extends StatefulWidget {
  historyCard({
    Key? key,
    required this.Data,
    required this.refused,
  }) : super(key: key);
  Result2 Data;
  bool refused;
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
              Navigator.push(
                context,
                CustomPageRoute(
                  child: HistoryPage2(
                    arguments: {
                      'dATE':Data.dATE,
                      'refused': widget.refused,
                      'shopname': Data.storeInfo!.name,
                      'address': Data.storeInfo!.address,
                      'discount': Data.discount,
                      'finalprice': Data.total,
                      'Data': Data,
                      'numbering': Data.sId,
                      'order': jsonDecode(Data.order!),
                      'id': Data.store,
                      'comments': Data.comments,
                    },
                  ),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Card(
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
                      height: Dimensions.screenHeigt / 4.4 -
                          Dimensions.height15 * 2,
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
                                            CachedNetworkImage(
                                              imageUrl:
                                                  'https://foodone-s3.s3.amazonaws.com/store/main/${Data.store}?${Data.dATE}',
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                height: Dimensions.screenHeigt /
                                                    9.17,
                                                width: Dimensions.screenWidth /
                                                    4.36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      Dimensions.radius15,
                                                    ),
                                                  ),
                                                  color: Colors.grey,
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                      'images/preImage.jpg',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Container(
                                                height: Dimensions.screenHeigt /
                                                    9.17,
                                                width: Dimensions.screenWidth /
                                                    4.36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      Dimensions.radius15,
                                                    ),
                                                  ),
                                                  color: Colors.grey,
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                      'images/preImage.jpg',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: Dimensions.screenHeigt /
                                                    9.17,
                                                width: Dimensions.screenWidth /
                                                    4.36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      Dimensions.radius15,
                                                    ),
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
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
                                                      fontFamily:
                                                          'NotoSansMedium',
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
                                                      text: '${totalNames()}',
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
                                        SizedBox(
                                          width: Dimensions.width15,
                                        ),
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.refused)
                  Container(
                    padding: EdgeInsets.all(Dimensions.height10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kMaimColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius20,
                      ),
                    ),
                    child: MiddleText(
                      color: kMaimColor,
                      text: '店家拒單',
                      fontFamily: 'NotoSansMedium',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
