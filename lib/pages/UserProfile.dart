import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/componentsUserProfile/UserCard.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/pages/Form3.dart';
import 'package:flutterdemo02/pages/login.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/BetweenSM.dart';
import '../models/TabsText.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void close() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FormPage3(),
        ),
        (route) => false);
  }

  bool? a = true;
  var name = TextEditingController(text: '');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var errorText = '';
  var errorStatus = '';

  Future inspect() async {
    var ss = await deleteAccount(UserSimplePreferences.getToken(), name.text);
    if (ss == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      ss = await deleteAccount(UserSimplePreferences.getToken(), name.text);
    }

    if (ss['status'] == '帳號已成功刪除') {
      errorText = ss['result'];
      errorStatus = ss['status'];
      setState(() {
        Get.snackbar(
          "$errorStatus",
          "$errorText",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        name.text = '';
      });
      await UserSimplePreferences.clearPreference();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (route) => false);
      await GoogleSignInApi.logout();
    } else {
      setState(() {
        errorText = ss['result'];
        errorStatus = ss['status'];
        Get.snackbar(
          "$errorStatus",
          "$errorText",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        name.text = '';
      });
    }
  }

  deleteAccount(key, name) async {
    debugPrint('正在用 "$name" 刪除帳號');
    var response = await http.delete(
      Uri.parse('https://www.foodone.tw/member'),
      headers: {
        "token": key,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {"name": name},
    );
    debugPrint('name is $name');
    debugPrint(
        'response statusCode in UserProfile.dart is ${response.statusCode}');
    var obj = (jsonDecode(response.body));

    debugPrint('obj is ${obj}');

    if (response.statusCode == 200) {
      return obj;
    } else if (response.statusCode == 400) {
      return obj;
    } else if (response.statusCode == 403) {
      return null;
    } else {
      return obj;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userdata = [
      User(
        name: '姓名',
        userName: UserSimplePreferences.getUserName(),
        edit: true,
        correct: true,
      ),
      User(
        name: 'Email',
        userName: UserSimplePreferences.getUserEmail(),
        edit: false,
      ),
      User(
        name: '生日',
        userName: UserSimplePreferences.getUserBirthday() ?? '尚未設定',
        edit: true,
        correct: false,
      ),
      User(
        name: '手機號碼',
        userName: UserSimplePreferences.getUserPhone() ?? '尚未設定',
        edit: true,
        correct: true,
        verify: UserSimplePreferences.getPhoneVerify() ?? false,
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.height15),
                child: GestureDetector(
                  onTap: () async {},
                  child: Container(
                    height: Dimensions.height50,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          a = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: kBottomColor,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MiddleText(
                                      color: kBodyTextColor,
                                      text: '輸入姓名刪除帳號',
                                      fontFamily: 'NotoSansMedium',
                                    ),
                                    SmallText(
                                        color: kTextLightColor,
                                        text: '前往首頁->左上方資訊欄->個人檔案->姓名')
                                  ],
                                ),
                                content: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: kMaim3Color)),
                                    child: TextField(
                                      controller: name,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        label: TabText(
                                          color: kTextLightColor,
                                          text: '請輸入你的姓名',
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius10),
                                          borderSide: BorderSide(
                                            color: kBottomColor!,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius10),
                                          borderSide: BorderSide(
                                            color: kBottomColor!,
                                          ),
                                        ),
                                        // errorText: titleError ? '不可為空' : null,
                                      ),
                                      //使用者輸入帳號有內鍵
                                      keyboardType: TextInputType.emailAddress,
                                      //使用者鍵盤多一個"done"鍵盤
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      '取消',
                                      style: TextStyle(color: kTextLightColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('確認'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (a == false) {
                            inspect();
                          }
                        },
                        child: BetweenSM(
                          color: Colors.red,
                          text: '刪除帳號',
                          fontFamily: 'NotoSansMedium',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: BetweenSM(
          color: kBodyTextColor,
          text: '個人檔案',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                height: Dimensions.height5,
              ),
              Column(
                children: List.generate(
                  userdata.length,
                  (index) => UserCard(
                    name: userdata[index].name,
                    username: userdata[index].userName,
                    edit: userdata[index].edit,
                    correct: userdata[index].correct,
                    verify: userdata[index].verify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future logout() => _googleSignIn.disconnect();
}

class User {
  const User({
    required this.name,
    required this.userName,
    required this.edit,
    this.correct,
    this.verify,
  });
  final String name;
  final String? userName;
  final bool edit;
  final bool? correct;
  final bool? verify;
}
