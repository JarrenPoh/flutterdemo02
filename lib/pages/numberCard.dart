import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../API/historyApi.dart';
import '../API/historyModel.dart';
import '../models/BetweenSM.dart';
import '../models/BigText.dart';
import '../models/ColorSettings.dart';
import '../models/MiddleText.dart';
import '../models/TabsText.dart';
import '../provider/Shared_Preference.dart';

class numberCard extends StatefulWidget {
  numberCard({Key? key}) : super(key: key);

  @override
  State<numberCard> createState() => _numberCardState();
}

class _numberCardState extends State<numberCard> {
  @override
  late Future<List<Result2?>?> stores;
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

  Timer? timer;
  static const maxSeconds = 3;
  int seconds = maxSeconds;
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds == 0) {
        seconds = maxSeconds;
        inspect();
      } else {
        seconds--;
      }
      print(seconds);
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    inspect();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: stores,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<Result2> data = snapshot.data;
          List<Result2> data2 = [];
          for (var i = 0; i < data.length; i++) {
            if (data[i].accept == true && data[i].complete == false) {
              data2.add(data[i]);
              print('data[i] is ${data[i]}');
            }
            
          }

          return AlertDialog(
            backgroundColor: kBottomColor,
            scrollable: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiddleText(
                  color: kBodyTextColor,
                  text: '領餐號碼牌',
                  fontFamily: 'NotoSansMedium',
                ),
              ],
            ),
            content: Column(
              children: List.generate(
                data2.length,
                (index) => Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TabText(
                            color: kBodyTextColor,
                            text: '${data2[index].storeInfo!.name}',
                            fontFamily: 'NotoSansMedium',
                          ),
                          Expanded(
                              child: Column(
                            children: const [],
                          )),
                          TabText(color: kBodyTextColor, text: '$index.')
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(
                            color: kBodyTextColor,
                            text: '70548',
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BetweenSM(
                            color: kBodyTextColor,
                            text: '金額\$ ${data[index].total}',
                          ),
                        ],
                      ),
                      const Divider()
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('確認'),
              ),
            ],
          );
        }
      },
    );
  }
}
