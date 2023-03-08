import 'dart:async';
import 'package:flutterdemo02/provider/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../API/historyApi.dart';
import '../API/historyModel.dart';
import '../models/BetweenSM.dart';
import '../models/BigText.dart';
import '../models/ColorSettings.dart';
import '../models/MiddleText.dart';
import '../models/TabsText.dart';
import '../provider/Shared_Preference.dart';
import 'numberCarSecond.dart';

class numberCard extends StatefulWidget {
  numberCard({Key? key}) : super(key: globals.globalToNumCard ?? key);

  @override
  State<numberCard> createState() => numberCardState();
}

class numberCardState extends State<numberCard> {
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
    setState(() {});
    return await stores;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    inspect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // timer?.cancel();
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
            if (data[i].complete != true) {
              data2.add(data[i]);
            }
          }

          var status = '';

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
              children: List.generate(data2.length, (index) {
                if (data2[index].accept == true &&
                    data2[index].finish == null) {
                  status = '備餐中';
                } else if (data2[index].accept == false &&
                    data2[index].finish == null) {
                  status = '審核中';
                } else if (data2[index].accept == true &&
                    data2[index].finish == true) {
                  status = '餐點完成';
                }
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/numbercardsecond',
                        arguments: {
                          'data2': data2[index],
                          'shopname': data2[index].storeInfo!.name,
                          'address': data2[index].storeInfo!.address,
                          'numbering': data2[index].sId,
                          'finalprice': data2[index].total,
                          'sequence': data2[index].sequence,
                          'reservation': data2[index].reservation,
                          'SId': data2[index].sId,
                          'accept': data2[index].accept,
                          'finish': data2[index].finish,
                          'comments': data2[index].comments,
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TabText(
                              color: kTextLightColor,
                              text: '${data2[index].storeInfo!.name}',
                              fontFamily: 'NotoSansMedium',
                            ),
                            Expanded(
                                child: Column(
                              children: const [],
                            )),
                            TabText(
                              color: kBodyTextColor,
                              text: 'NO.${data2[index].sequence}',
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TabText(
                              color: kBodyTextColor,
                              text: '金額\$ ${data2[index].total}',
                              fontFamily: 'NotoSansMedium',
                            ),
                            Expanded(
                              child: Column(
                                children: const [],
                              ),
                            ),
                            SmallText(
                              color: status == '備餐中' || status == '審核中'
                                  ? kMaimColor
                                  : Colors.green,
                              text: '$status',
                              fontFamily: 'NotoSansMedium',
                            ),
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  ),
                );
              }),
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
