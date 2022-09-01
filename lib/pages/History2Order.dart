import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/componentsHistory/history21st.dart';
import 'package:flutterdemo02/componentsHistory/history3rd.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';

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
      int inin = order[i]['price'];
      totalprice += inin;
      print('totalprice1 is $totalprice');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.white,
=======
>>>>>>> 975116e107f9fc3e38a1fe08de2f76c4e6a1010c
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
                          onPressed: () {},
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
                    if (arguments['image'] != null)
                      Image.asset(
                        arguments['image'],
                        fit: BoxFit.cover,
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
                    SizedBox(height: Dimensions.height15),
                    SizedBox(height: Dimensions.height15),
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
                    const Divider(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.height10),
                      child: Column(
                        children: List.generate(order.length, (index) {
                          return history2nd(
                              describes: order[index]['note'],
                              name: order[index]['name'],
                              price: order[index]['price'],
                              options: jsonDecode(order[index]['options']),
                              counts: order[index]['count']);
                        }),
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
