import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/loginApi.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_version/new_version.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutterdemo02/provider/globals.dart' as globals;
import '../API/oneSignalApi.dart';
import '../provider/Shared_Preference.dart';
import '../provider/local_notification_service.dart';
import 'Form4.dart';
import 'numberCarSecond.dart';

// import 'package:flutter_progress_hud/flutter_progress_hud.dart';

// import 'package:flutter_pro';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  void initState() {
    _checkVersion();
    // TODO: implement initState
    super.initState();
  }

  void _checkVersion() async {
    // final newVersion = NewVersion(androidId: 'com.FORDON.flutterdemo02');
    final newVersion = NewVersion(
      iOSId: 'com.google.Vespa',
      androidId: 'com.snapchat.android',
    );
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
            context: context,
            versionStatus: status,
            dialogTitle: '更新',
            allowDismissal: true,
            dismissButtonText: '退出',
            dialogText: '請更新foodone app至最高版本',
            updateButtonText: '更新',
            dismissAction: () {
              SystemNavigator.pop();
            });
      }
    }

    debugPrint('device version : ${status!.localVersion}');
    debugPrint('store version : ${status.storeVersion}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x66ED1C24),
                            Color(0x99ED1C24),
                            Color(0xccED1C24),
                            Color(0xFFED1C24),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height20 * 2,
                            ),
                            ElevatedButton.icon(
                              onPressed: signIn,
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                              ),
                              label: TabText(
                                color: kBodyTextColor,
                                text: 'Sign Up with Goolgle ',
                                fontFamily: 'NotoSansBold',
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                minimumSize: Size(
                                    double.infinity - Dimensions.width20, 50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  var userID;
  Future signIn() async {
    setState(() {
      isLoading = true;
    });
    final user = await GoogleSignInApi.login();
    GoogleSignIn().signIn().then((result) {
      result!.authentication.then((googleKey) async {
        print('googleKey.accessToken is ${googleKey.accessToken}');
        String? key = googleKey.accessToken;
        await UserSimplePreferences.setGoogleKey(key!);
        print('object1');
        var users =
            await loginApi.getUsers(UserSimplePreferences.GetGoogleKey());
        print('object2');
        await UserSimplePreferences.setRefreshToken(
            users!.headers['refresh_token']!);
        print('object3');
        Map list = jsonDecode(users.body);
        await UserSimplePreferences.setUserInformation(
          list['result']['email'],
          list['result']['name'],
          list['result']['picture'],
        );

        OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

        await OneSignal.shared.setAppId("ec271f5c-c5ee-4465-8f82-9e5be14bd308");
        print('object7');
        OneSignal.shared.getDeviceState().then(
          (value) {
            userID = value!.userId;
            print('userID0 is $userID');
            if (userID != null) {
              UserSimplePreferences.setOneSignalAppID(userID);
            }
          },
        );
        if (userID != null) {
          await UserSimplePreferences.setOneSignalAppID(userID);
        }

        print('object8');
        print('第二個${users.headers}');
        print('第二個${users.body}');
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(
          context,
          '/splash',
        );
      }).catchError((err) {
        print(err);
        print('inner error');
      });
    }).catchError((err) {
      print('error occured');
    });
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future logout() => _googleSignIn.disconnect();
}
