import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutterdemo02/API/UserUpdateApi.dart';
import 'package:flutterdemo02/API/twilioApi.dart';
import 'package:flutterdemo02/components5/textField.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../models/ColorSettings.dart';
import '../models/MiddleText.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:get/get.dart';

class UserCorrect extends StatefulWidget {
  UserCorrect({Key? key, required this.arguments}) : super(key: key);
  Map arguments;
  @override
  State<UserCorrect> createState() => _UserCorrectState(arguments: arguments);
}

class _UserCorrectState extends State<UserCorrect> {
  _UserCorrectState({required this.arguments});
  Map arguments;
  void close() {
    Navigator.pop(context);
  }

  late TwilioFlutter twilioFlutter;
  var textController = TextEditingController(
    text: UserSimplePreferences.getUserPhone(),
  );
  bool _validate = false;
  bool _errortext = false;
  bool _ifsend = false;
  bool _validate2 = false;
  bool _errortext2 = false;
  bool _isLoading = true;
  bool verifyError2 = false;
  bool verifyError = false;
  String varifyErrorText2 = '';
  String varifyErrorText = '';
  var textController2 = TextEditingController();
  @override
  void initState() {
    _validate = textController.text == '' ? false : true;
    textController.addListener(() {
      textController.text.length == 10 ? _validate = true : _validate = false;
      textController.text.length == 10 ? _errortext = false : null;
      setState(() {});
    });
    textController2.addListener(() {
      textController2.text.length == 8 ? _validate2 = true : _validate2 = false;
      textController2.text.length == 8 ? _errortext2 = false : null;
      setState(() {});
    });
    super.initState();
  }

  Future putuser(birthday, phone, token) async {
    var putusers = await UserUpdateApi.putUsers(birthday, phone, token);
    //token到期
    if (putusers == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      putusers = await UserUpdateApi.putUsers(
          birthday, phone, UserSimplePreferences.getToken());
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
      if (obj['result']['birthday'] != null) {
        await UserSimplePreferences.setUserBirthday(
          obj['result']['birthday'],
        );
      }
    }
  }

  String? getsms;
  Future getSMS(token) async {
    getsms = await twilioApi.getSMS(token);
    //token到期
    if (getsms == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      getsms = await twilioApi.getSMS(UserSimplePreferences.getToken());
    }
  }

  String? sendverify;
  Future sendVerify(token, code) async {
    sendverify = await twilioApi.getVerify(token, code);
    //token到期
    if (sendverify == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      sendverify =
          await twilioApi.getVerify(UserSimplePreferences.getToken(), code);
    }
    setState(() {});
    return sendverify;
  }

  static const maxSeconds = 30;
  Timer? timer;
  bool timerStart = false;
  int seconds = maxSeconds;
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds == 0) {
        setState(() {
          print('stop');
          seconds = maxSeconds;
          timerStart = false;
          _ifsend = true;
          _validate = true;
          timer?.cancel();
        });
      } else {
        setState(() {
          print('go');
          seconds--;
          timerStart = true;
        });
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe8e8e8),
              blurRadius: 5.0,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.height15),
                child: GestureDetector(
                  onTap: () async {
                    String? text;
                    if (textController.text.isNotEmpty) {
                      text = textController.text;
                    } else {
                      text = null;
                    }
                    Navigator.pop(context, text);
                  },
                  child: Card(
                    borderOnForeground: false,
                    color: Color.fromARGB(255, 196, 195, 195),
                    child: Container(
                      height: Dimensions.height50,
                      child: Center(
                        child: BetweenSM(
                          color: Colors.white,
                          text: '確認',
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
          text: arguments['name'],
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height15,
          horizontal: Dimensions.width20,
        ),
        child: Stack(
          children: [
            !_isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Column(
              children: [
                Row(
                  children: [
                    TabText(
                      color: kBodyTextColor,
                      text: '請填寫你的手機號碼並驗證',
                      fontFamily: 'NotoSansMedium',
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.height20),
                  child: TextField(
                    controller: textController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: '請輸入您的手機號碼',
                      errorText: _errortext == true
                          ? '格式錯誤'
                          : verifyError==true
                              ? varifyErrorText
                              : null,
                      label: TabText(
                        color: kTextLightColor,
                        text: '手機號碼',
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                        borderSide: BorderSide(
                          color: kBottomColor!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                        borderSide: const BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          timerStart
                              ? Container(
                                  height: Dimensions.height50 / 1.5,
                                  child: Center(
                                    child: Text(
                                      '$seconds sec',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(),
                          GestureDetector(
                            onTap: _validate
                                ? () async {
                                    String? text;
                                    if (textController.text.isNotEmpty) {
                                      text = textController.text;
                                    } else {
                                      text = null;
                                    }
                                    setState(() {
                                      _validate = false;
                                      _isLoading = false;
                                    });
                                    await putuser(
                                        UserSimplePreferences.getUserBirthday(),
                                        text,
                                        UserSimplePreferences.getToken());

                                    await getSMS(
                                        UserSimplePreferences.getToken());
                                    print('getsms is $getsms');
                                    if (getsms == '成功請求驗證簡訊') {
                                      setState(
                                        () {
                                          _isLoading = true;
                                          _ifsend = true;

                                          startTimer();
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        varifyErrorText = getsms!;
                                        verifyError=true;
                                        _isLoading = true;
                                        _validate = true;
                                      });
                                    }
                                  }
                                : () {
                                    setState(() {
                                      _errortext = true;
                                    });
                                  },
                            child: Card(
                              borderOnForeground: false,
                              color: _validate
                                  ? kMaimColor
                                  : Color.fromARGB(255, 196, 195, 195),
                              child: Container(
                                height: Dimensions.height50 / 1.5,
                                child: Center(
                                  child: TabText(
                                    color: Colors.white,
                                    text: '發送簡訊',
                                    fontFamily: 'NotoSansMedium',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          timerStart
                              ? Container(
                                  height: Dimensions.height50 / 1.5,
                                  child: Center(
                                    child: Text('$seconds sec'),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.height20 * 3.3),
                  child: TextField(
                    controller: textController2,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: '請輸入簡訊驗證碼',
                      label: TabText(
                        color: kTextLightColor,
                        text: '簡訊驗證',
                      ),
                      errorText: _errortext2 == true
                          ? '驗證碼為8位數'
                          : verifyError2 == true
                              ? varifyErrorText2
                              : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                        borderSide: BorderSide(
                          color: kBottomColor!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                        borderSide: const BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height15,
                    horizontal: Dimensions.width20 * 6.5,
                  ),
                  child: GestureDetector(
                    onTap: _validate2 && _ifsend
                        ? () async {
                            String? text;
                            if (textController2.text.isNotEmpty) {
                              text = textController2.text;
                            } else {
                              text = null;
                            }
                            setState(() {
                              _isLoading = false;
                            });

                            await sendVerify(
                              UserSimplePreferences.getToken(),
                              text,
                            );
                            print('sendverify is ${sendverify}');
                            if (sendverify == '驗證成功') {
                              _isLoading = true;
                              Navigator.pop(context, text);
                            } else {
                              setState(
                                () {
                                  _isLoading = true;
                                  varifyErrorText2 = sendverify!;
                                  verifyError2 = true;
                                  _ifsend = true;
                                  _validate2 = true;
                                  _validate = false;
                                },
                              );
                            }
                          }
                        : () {
                            setState(() {
                              _errortext2 = true;
                            });
                          },
                    child: Card(
                      borderOnForeground: false,
                      color: _validate2 && _ifsend
                          ? kMaimColor
                          : Color.fromARGB(255, 196, 195, 195),
                      child: Container(
                        height: Dimensions.height50 / 1.5,
                        child: Center(
                          child: TabText(
                            color: Colors.white,
                            text: '確認',
                            fontFamily: 'NotoSansMedium',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
