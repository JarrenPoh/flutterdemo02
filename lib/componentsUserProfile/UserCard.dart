import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/UserUpdateApi.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:flutterdemo02/pages/UserCorrect.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../models/ColorSettings.dart';
import '../models/MiddleText.dart';
import '../models/TabsText.dart';
import '../provider/Shared_Preference.dart';

class UserCard extends StatefulWidget {
  UserCard({
    Key? key,
    required this.name,
    required this.username,
    required this.edit,
    this.correct,
    this.verify,
  }) : super(key: key);
  String name;
  String? username;
  bool edit;
  bool? correct;
  bool? verify;
  @override
  State<UserCard> createState() => _UserCardState(
        name: name,
        username: username,
        edit: edit,
        correct: correct,
        verify: verify,
      );
}

class _UserCardState extends State<UserCard> {
  _UserCardState({
    required this.name,
    required this.username,
    required this.edit,
    this.correct,
    this.verify,
  });
  DateTime date = DateTime(1995, 10, 17);
  bool edit;
  bool? correct;
  String name;
  String? username;
  bool? verify;
  Future putuser(birthday, phone, token, name) async {
    var putusers = await UserUpdateApi.putUsers(birthday, phone, token, name);
    //token到期
    if (putusers == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      putusers = await UserUpdateApi.putUsers(
          birthday, phone, UserSimplePreferences.getToken(), name);
    }
  }

  Future getuser(token) async {
    var getusers = await UserUpdateApi.getUsers(token);
    //token到期
    if (getusers == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      getusers = await UserUpdateApi.getUsers(UserSimplePreferences.getToken());
    }
    if (getusers!.statusCode == 200) {
      var obj = (jsonDecode(getusers.body));
      if (obj!['result']['phone'] != null) {
        await UserSimplePreferences.setUserPhone(obj!['result']['phone']);
      }
      if (obj!['result']['name'] != null) {
        await UserSimplePreferences.setUserInformation(
            null, obj!['result']['name'], null);
      }
      if (obj['result']['birthday'] != null) {
        await UserSimplePreferences.setUserBirthday(
          obj['result']['birthday'],
        );
      }
      if (obj['result']['phoneVerify'] == true) {
        await UserSimplePreferences.setPhoneVerify(
          obj['result']['phoneVerify'],
        );
        verify = UserSimplePreferences.getPhoneVerify();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width10, vertical: Dimensions.height15),
      width: Dimensions.screenWidth,
      child: GestureDetector(
        onTap: () async {
          ////手機或名字////
          if (edit && correct!) {
            var later = await Navigator.push(
              context,
              CustomPageRoute(
                child: UserCorrect(
                  arguments: {'name': name, 'username': username},
                ),
              ),
            );
            if (later == null) {
              return;
            } else {
              await getuser(UserSimplePreferences.getToken());
              setState(
                () {
                  if (name == '手機號碼') {
                    username = UserSimplePreferences.getUserPhone();
                    Get.snackbar(
                      "修改成功",
                      "您已修改了新的$name為 $username ",
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  } else {
                    username = UserSimplePreferences.getUserName();
                    Get.snackbar(
                      "修改成功",
                      "您已修改了新的$name為 $username ",
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
              );
            }
            ////生日////
          } else if (edit && !correct!) {
            var newData = await showDatePicker(
              context: context,
              initialDate: DateTime(1995, 10, 17),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: kMaim3Color,
                        onPrimary: Colors.white,
                        onSurface: Colors.blueAccent,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          primary: Colors.red,
                        ),
                      ),
                    ),
                    child: child!);
              },
            );

            var newDataStr = newData.toString();
            var newDate = newDataStr.substring(0, 10);
            if (newData == null) {
              return;
            } else {
              await putuser(
                newDate,
                UserSimplePreferences.getUserPhone(),
                UserSimplePreferences.getToken(),
                UserSimplePreferences.getUserName(),
              );
              await getuser(
                UserSimplePreferences.getToken(),
              );

              setState(() {
                date = newData;
                username = newDate;
                Get.snackbar(
                  "修改成功",
                  "您已修改了新的$name為 $username ",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              });
            }
          }
        },
        child: Card(
          color: Colors.white,
          elevation: Dimensions.height5,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
          ),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              ListTile(
                title: Column(
                  children: [
                    Divider(
                      height: Dimensions.height15,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        TabText(
                          text: name,
                          color: kBodyTextColor,
                          fontFamily: 'NotoSansRegular',
                        ),
                        Column(
                          children: [
                            Container(
                              width: 50,
                            )
                          ],
                        ),
                        if (verify != null &&
                            verify == true &&
                            correct == true &&
                            name == '手機號碼')
                          Container(
                            color: kBottomColor,
                            child: TabText(
                              text: '已驗證',
                              color: kBodyTextColor,
                              fontFamily: 'NotoSansRegular',
                            ),
                          ),
                        if (verify == false && correct == true)
                          Container(
                            color: kMain2Color,
                            child: TabText(
                              text: '未驗證',
                              color: kBodyTextColor,
                              fontFamily: 'NotoSansRegular',
                            ),
                          ),
                      ],
                    ),
                    Divider(
                      height: Dimensions.height10,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        BetweenSM(
                          text: '$username',
                          color: kBodyTextColor,
                          fontFamily: 'NotoSansMedium',
                        ),
                      ],
                    ),
                    Divider(
                      height: Dimensions.height15,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: Dimensions.height10,
                  ),
                  if (edit)
                    Icon(
                      Icons.edit_rounded,
                      color: kMaimColor,
                      size: Dimensions.icon25,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
