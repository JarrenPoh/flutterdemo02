import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/pages/Form3.dart';
import 'package:flutterdemo02/pages/login.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
    FirebaseAnalytics.instance.logAppOpen();
    super.initState();
  }

  Future<String?> onesignalSuscribe() async {
    String? result = '';
    result = await OneSignalapi.getOneSignal(
        UserSimplePreferences.getOneSignalAppID()!,
        UserSimplePreferences.getToken());
    print(
      '這台手機尚未訂閱oneSinal帳號或手機裝置不同, 完成為 ${UserSimplePreferences.getOneSignalApiDone()}',
    );
    if (result == 'failed') {
      onesignalSuscribe();
    }

    return result;
  }

  void TokenApiInspect() async {
    var getToken = await getTokenApi
        .getToken(UserSimplePreferences.getRefreshToken()); //2sec
    if (getToken.statusCode == 200) {
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      ////FIrebase/////
      await FirebaseAnalytics.instance.logEvent(
        name: 'login_success_detail',
        parameters: {
          'name': UserSimplePreferences.getUserName(),
          'gmail': UserSimplePreferences.getUserEmail(),
          'phone': UserSimplePreferences.getUserPhone(),
        },
      );
      ////////////////

      var appid;

      OneSignal.shared.getDeviceState().then(
        (value) async {
          appid = value!.userId!;
          print('userid2 is $appid');
          if (appid != null ||
              appid != UserSimplePreferences.getOneSignalAppID()) {
            print('object0');
            await UserSimplePreferences.setOneSignalAppID(appid);
            await UserSimplePreferences.setOneSignalApiDone(false);
            print('object1');
            if (UserSimplePreferences.getOneSignalApiDone() != true &&
                UserSimplePreferences.getOneSignalAppID() != null &&
                UserSimplePreferences.getToken() != null) {
              onesignalSuscribe();
            }
          }
        },
      );
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

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FormPage3()),
          (route) => false);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  void spectator() async {
    final newVersion = NewVersionPlus(
      // androidId: 'com.tencent.mm',
      // androidId: 'com.canva.editor',
      androidId: 'com.FORDON.flutterdemo02',
      iOSId: 'com.FORDON.flutterdemo02',
    );

    // final status = await newVersion.getVersionStatus();
    // if (status != null) {
    //   if (status.canUpdate) {
    //     newVersion.showUpdateDialog(
    //       context: context,
    //       versionStatus: status,
    //       dialogTitle: '更新',
    //       allowDismissal: false,
    //       // dismissButtonText: '退出',
    //       dialogText: '請更新foodone app至最高版本',
    //       updateButtonText: '更新',
    //       // dismissAction: () {
    //       //   SystemNavigator.pop();
    //       // }
    //     );
    //   } else {
        //沒有Goolglekey就去login
        if (UserSimplePreferences.GetGoogleKey() == null) {
          print('object');
          Timer(Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          });
          //沒有refreshToken但有googlekey就去存refreshtoken
        } else if (UserSimplePreferences.GetGoogleKey() != null &&
            UserSimplePreferences.getRefreshToken() == null) {
          print('object1');
          var users =
              await loginApi.getGoogleUsers(UserSimplePreferences.GetGoogleKey());
          ////googleKey過期才會申請失敗，else if 轉到login
          if (users != null) {
            print('object12');
            await UserSimplePreferences.setRefreshToken(
                users.headers['refresh_token']!);
            Map list = jsonDecode(users.body);
            await UserSimplePreferences.setUserInformation(
                list['result']['email'],
                list['result']['name'],
                list['result']['picture']);
            // print('第二個${users.headers}');
            // print('第二個${users.body}');f
            TokenApiInspect();
            //有refreshToken
          } else if (users == null) {
            Timer(
              Duration(seconds: 1),
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            );
          }
        } else if (UserSimplePreferences.getRefreshToken() != null) {
          TokenApiInspect();
        }
    //   }
    // }
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
