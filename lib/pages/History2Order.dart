import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo02/componentsHistory/history21st.dart';
import 'package:flutterdemo02/componentsHistory/history3rd.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/pages/Form4.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';

import '../componentsHistory/history2nd.dart';
import '../models/BigText.dart';
import '../models/ColorSettings.dart';

class HistoryPage2 extends StatefulWidget {
  Map arguments;
  HistoryPage2({Key? key, required this.arguments}) : super(key: key);

  @override
  State<HistoryPage2> createState() => _HistoryPage2State(arguments: arguments);
}

class _HistoryPage2State extends State<HistoryPage2> {
  Map arguments;
  _HistoryPage2State({required this.arguments});
  List order = [];
  int totalprice = 0;
  @override
  void initState() {
    order = arguments['order'];
    for (var i = 0; i < order.length; i++) {
      int inin = order[i]['price']*order[i]['count'];
      totalprice += inin;
      print('totalprice1 is $totalprice');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  color: kMaimColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                            context,
                            CustomPageRoute(
                              child: FormPage4(
                                arguments: {
                                  'id': arguments['id'],
                                },
                              ),
                            ),
                          );
                          },
                          child: TabText(
                            color: Colors.white,
                            text: '前往店家',
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.west,
                  color: kMaimColor,
                ),
              ),
              expandedHeight: 200,
              //往上滑一點APPBAR就會跑出來
              // floating: true,
              //只有Expanded的部分會隱藏
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://foodone-s3.s3.amazonaws.com/store/main/${arguments['id']}?${arguments['dATE']}',
                      errorWidget: (context, url, error) => Container(
                        width: Dimensions.screenWidth,
                        height: Dimensions.screenHeigt / 4.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                              Dimensions.screenWidth,
                              30,
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
                      progressIndicatorBuilder: (context, url, progress) =>
                          Container(
                        width: Dimensions.screenWidth,
                        height: Dimensions.screenHeigt / 4.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                              Dimensions.screenWidth,
                              30,
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
                      imageBuilder: (context, imageProvider) => Container(
                        width: Dimensions.screenWidth,
                        height: Dimensions.screenHeigt / 4.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                              Dimensions.screenWidth,
                              30,
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
                //在上升的時候背景圖片固定
                collapseMode: CollapseMode.pin,
                // title: Text('My App Bar'),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: Dimensions.width10,
                  right: Dimensions.width10,
                  top: Dimensions.height15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(
                      color: kBodyTextColor,
                      text: arguments['shopname'],
                      weight: FontWeight.bold,
                    ),
                    SizedBox(height: Dimensions.height15 * 2),
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
                    ),
                    SizedBox(height: Dimensions.height15),
                    BetweenSM(
                      color: kBodyTextColor,
                      text: '店家留言',
                      fontFamily: 'NotoSansMedium',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TabText(
                          color: Colors.black87,
                          text: arguments['comments'] == null ||
                                  arguments['comments'] == 'null'
                              ? '無'
                              : arguments['comments'],
                        ),
                      ],
                    ),
                    const Divider(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.height10),
                      child: Column(
                        children: List.generate(
                          order.length,
                          (index) {
                            return history2nd(
                                describes: order[index]['note'],
                                name: order[index]['name'],
                                price: order[index]['price'],
                                options: jsonDecode(order[index]['options']),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
