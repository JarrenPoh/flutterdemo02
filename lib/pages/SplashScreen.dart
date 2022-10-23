import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:flutterdemo02/API/loginApi.dart';
import '../API/UserUpdateApi.dart';
import '../API/oneSignalApi.dart';
import '../provider/Shared_Preference.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({
    Key? key,
  }) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
    spectator();
    super.initState();
  }

  void TokenApiInspect() async {
    var getToken = await getTokenApi
        .getToken(UserSimplePreferences.getRefreshToken()); //2sec
    if (getToken.statusCode == 200) {
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      ////FIrebase/////
      await FirebaseAnalytics.instance.logEvent(
        name: 'login_success',
        parameters: {
          'name': UserSimplePreferences.getUserName(),
          'gmail': UserSimplePreferences.getUserEmail(),
          'picture': UserSimplePreferences.getUserPicture(),
        },
      );
      ////////////////
      ////oneSinal/////
      // print(
      //     'getOneSignalAppID is ${UserSimplePreferences.getOneSignalAppID()}');
      if (UserSimplePreferences.getOneSignalApiDone() == null&&UserSimplePreferences.getOneSignalAppID() != null&&
      UserSimplePreferences.getToken() != null) {
        OneSignalapi.getOneSignal(UserSimplePreferences.getOneSignalAppID()!,
            UserSimplePreferences.getToken());
      }
      ////////////////
      print(
          'UserSimplePreferences is ${UserSimplePreferences.getUserBirthday()}');
      print('UserSimplePreferences is ${UserSimplePreferences.getUserPhone()}');
      print(
          'UserSimplePreferences is ${UserSimplePreferences.getPhoneVerify()}');
      if (UserSimplePreferences.getUserBirthday() == null ||
          UserSimplePreferences.getUserPhone() == null ||
          UserSimplePreferences.getPhoneVerify() == null) {
        var getusers =
            await UserUpdateApi.getUsers(UserSimplePreferences.getToken());
        var obj = (jsonDecode(getusers!.body));
        if (obj['result']['birthday'] != null) {
          await UserSimplePreferences.setUserBirthday(
              obj['result']['birthday']);
        }
        if (obj['result']['phone'] != null) {
          await UserSimplePreferences.setUserPhone(obj['result']['phone']);
        }
        if (obj['result']['phoneVerify'] != null) {
          await UserSimplePreferences.setPhoneVerify(
              obj['result']['phoneVerify']);
        }
      }

      Navigator.pushNamedAndRemoveUntil(context, '/form3', (route) => false);
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/login',
      );
    }
  }

  void spectator() async {
    //沒有Goolglekey就去login
    if (UserSimplePreferences.GetGoogleKey() == null) {
      print('object');
      Timer(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
      //沒有refreshToken但有googlekey就去存refreshtoken
    } else if (UserSimplePreferences.GetGoogleKey() != null &&
        UserSimplePreferences.getRefreshToken() == null) {
      print('object1');
      var users = await loginApi.getUsers(UserSimplePreferences.GetGoogleKey());
      ////googleKey過期才會申請失敗，else if 轉到login
      if (users != null) {
        print('object12');
        await UserSimplePreferences.setRefreshToken(
            users.headers['refresh_token']!);
        Map list = jsonDecode(users.body);
        await UserSimplePreferences.setUserInformation(list['result']['email'],
            list['result']['name'], list['result']['picture']);
        // print('第二個${users.headers}');
        // print('第二個${users.body}');
        TokenApiInspect();
        //有refreshToken
      } else if (users == null) {
        Timer(
          Duration(seconds: 1),
          () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        );
      }
    } else if (UserSimplePreferences.getRefreshToken() != null) {
      TokenApiInspect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset(
        'images/foodone_page-0001_4-removebg-preview.png',
      ),
    );
  }
}
