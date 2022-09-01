import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
// import 'package:flutterdemo02/API/StoreModel.dart';
import 'package:flutterdemo02/API/historyModel.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'dart:convert';
import '../API/historyApi.dart';
import '../componentsHistory/historyCard.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Result2?>?> stores;

  StoreInfo? storeInfo;
  int finalPrice = 0;
  bool tableWare = false;

  ////////////
  Future inspect() async {
    var ss = await spectator();
    if (ss == null) {
      String? refresh_token = await UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      stores = HistoryApi.getStores(UserSimplePreferences.getToken());

      setState(() {});
    }
    return await stores;
  }

  Future spectator() async {
    stores = HistoryApi.getStores(UserSimplePreferences.getToken());
    return await stores;
  }

  

  ////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inspect();
    
  }

 

  void close() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: BetweenSM(
          color: kBodyTextColor,
          text: '歷史紀錄',
          fontFamily: 'NotoSansMedium',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: kMaimColor,
            size: Dimensions.icon25,
          ),
          onPressed: close,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Result2?>?>(
          future: stores,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<Result2> data = snapshot.data;

              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Dimensions.width20,
                        right: Dimensions.width15,
                        top: Dimensions.height20,
                        bottom: Dimensions.height5),
                    child: Row(
                      children: [
                        MiddleText(
                          color: kBodyTextColor,
                          text: '過去訂購的商品',
                          fontFamily: 'NotoSansMedium',
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: List.generate(
                      data.length,
                      (index) {
                        return historyCard(
                          Data: data[index],
                          // orderSet:orderSet,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
