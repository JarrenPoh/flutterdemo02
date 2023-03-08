import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/MenuModel.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/pages/Tabs.dart';

import '../models/MiddleText.dart';

class RappiProductItem extends StatefulWidget {
  Result3 data3;
  bool businessTime;
  String last_update;
  RappiProductItem(
    this.product,
    this.data3,
    this.businessTime,
    this.last_update,
  );
  final Result product;

  @override
  State<RappiProductItem> createState() =>
      _RappiProductItemState(data3: data3, businessTime: businessTime);
}

class _RappiProductItemState extends State<RappiProductItem>{

  Result3 data3;
  _RappiProductItemState({required this.data3, required this.businessTime});
  List options = [];
  bool businessTime;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    imageUrl =
        'https://foodone-s3.s3.amazonaws.com/store/product/${widget.product.id}?${widget.last_update}';

    if (widget.product.options != null) {
      options = jsonDecode(widget.product.options!);
    }

    return SizedBox(
      height: productHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
        child: GestureDetector(
          onTap: () async {
            if (businessTime == true) {
              cartController.deleteindex = null;
              await Navigator.pushNamed(
                context,
                '/form5',
                arguments: {
                  'id': true,
                  'Id': widget.product.id,
                  'name': widget.product.name,
                  'price': int.parse(widget.product.price),
                  'textprice': widget.product.price,
                  'description': widget.product.describe,
                  'shopname': data3.name,
                  'ToCart': '加入購物車',
                  'firstNumber': 1,
                  'options': options,
                  'imageUrl': imageUrl,
                },
              );
            } else if (businessTime == false) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: MiddleText(
                    color: kBodyTextColor,
                    text: '店家尚未營業',
                    fontFamily: 'NotoSansMedium',
                  ),
                  content: Column(
                    children: [
                      TabText(
                        color: kBodyTextColor,
                        text: '很抱歉，店家未營業時無法訂購餐點',
                        fontFamily: 'NotoSansMedium',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: TabText(
                        color: Colors.blue,
                        text: '知道了',
                        fontFamily: 'NotoSansMedium',
                      ),
                    ),
                  ],
                ),
              );
              setState(() {});
            }
          },
          child: Card(
            elevation: Dimensions.height5,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: Dimensions.width10,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: Dimensions.width10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BetweenSM(
                          color: kBodyTextColor,
                          text: widget.product.name,
                          weight: FontWeight.normal,
                          fontFamily: 'NotoSansMedium',
                        ),
                        if (widget.product.describe != null)
                          SmallText(
                            color: kTextLightColor,
                            text: widget.product.describe!,
                          ),
                        SizedBox(
                          height: Dimensions.height5,
                        ),
                        Text(
                          '\$ ${widget.product.price}',
                          style: const TextStyle(
                              color: kMaimColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              fontFamily: 'NotoSansMedium'),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                      horizontal: Dimensions.width10),
                  child: SizedBox(
                    height: Dimensions.screenHeigt / 9.17,
                    width: Dimensions.screenWidth / 4.36,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      child: Column(
                        children: [
                          if (widget.product.id != null)
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              errorWidget: (context, url, error) => Container(
                                height: Dimensions.screenHeigt / 9.17,
                                width: Dimensions.screenWidth / 4.36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15,
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
                                  (context, url, progress) => Container(
                                height: Dimensions.screenHeigt / 9.17,
                                width: Dimensions.screenWidth / 4.36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15,
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: Dimensions.screenHeigt / 9.17,
                                width: Dimensions.screenWidth / 4.36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius15,
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          // if (widget.product.image == null)
                          //   Container(
                          //     height: Dimensions.screenHeigt / 9.17,
                          //     width: Dimensions.screenWidth / 4.36,
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //         image: NetworkImage(
                          //           'https://images.unsplash.com/photo-1626082929543-5bab0f090c42?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8RlJJRUQlMjBDSElDS0VOfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                          //         ),
                          //         fit: BoxFit.cover,
                          //       ),
                          //       color: Colors.grey,
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(
                          //           Dimensions.radius15,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
