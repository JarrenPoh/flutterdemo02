import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';

class contactWay extends StatefulWidget {
  const contactWay({Key? key}) : super(key: key);

  @override
  State<contactWay> createState() => _contactWayState();
}

class _contactWayState extends State<contactWay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10,
                horizontal: Dimensions.width15,
              ),
              child: Text(
                '聯絡方式',
                style: TextStyle(fontSize: Dimensions.fontsize24),
              )),
        ),
        ListTile(
          leading: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height10,
              horizontal: Dimensions.width15,
            ),
            child: Icon(
              Icons.person_rounded,
              size: Dimensions.icon25,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(
              left: Dimensions.width15,
              top: Dimensions.height15,
            ),
            child: Row(
              children: [
                MiddleText(
                  color: kBodyTextColor,
                  text: '姓名',
                  fontFamily: 'NotoSansMedium',
                ),
                Expanded(
                  child: Column(
                    children: const [],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(left: Dimensions.width15),
            child: Column(
              children: [
                BetweenSM(
                    color: kBodyTextColor,
                    text: '${UserSimplePreferences.getUserName()}'),
                const Divider(),
              ],
            ),
          ),
        ),
        ListTile(
          leading: Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10, horizontal: Dimensions.width15),
            child: Icon(
              Icons.phone_in_talk_rounded,
              size: Dimensions.icon25,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: Dimensions.width15),
            child: Row(
              children: [
                MiddleText(
                  color: kBodyTextColor,
                  text: '手機',
                  fontFamily: 'NotoSansMedium',
                ),
                Expanded(
                  child: Column(
                    children: const [],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(left: Dimensions.width15),
            child: Column(
              children: [
                BetweenSM(
                  color: kBodyTextColor,
                  text: UserSimplePreferences.getUserPhone() == null
                      ? '尚未設定'
                      : '${UserSimplePreferences.getUserPhone()}',
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
