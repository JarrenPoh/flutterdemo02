import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/loginApi.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_version/new_version.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../provider/Shared_Preference.dart';

import 'package:sign_button/sign_button.dart' as button;

import '../provider/authentication_viewmodel.dart';

// import 'package:flutter_progress_hud/flutter_progress_hud.dart';

// import 'package:flutter_pro';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isLoading = false;
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // _checkVersion();
    // TODO: implement initState
    super.initState();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(androidId: 'com.FORDON.flutterdemo02');

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

    debugPrint('device version : ${status?.localVersion}');
    debugPrint('store version : ${status?.storeVersion}');
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
                        child: Stack(
                          children: [
                            Column(
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
                                  height: Dimensions.height20 * 3,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: Dimensions.height15 * 3,
                                        child: button.SignInButton(
                                          buttonType: button.ButtonType.google,
                                          buttonSize: button.ButtonSize
                                              .medium, // small(default), medium, large
                                          onPressed: signIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                if (Platform.isIOS)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: Dimensions.height15 * 3,
                                          child: button.SignInButton(
                                            buttonType: button.ButtonType.apple,
                                            buttonSize: button.ButtonSize
                                                .medium, // small(default), medium, large
                                            onPressed: AppleSignIn,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const Positioned(
                              bottom: 50,
                              right: 15,
                              child: Text(
                                'Foodone - 福團團',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
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

// AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  Future<void> AppleSignIn() async {
    try {
      final authService = ref.watch(authappleService);
      final user = await authService
          .signInWithApple(scopes: [Scope.email, Scope.fullName]);
      print('uid: ${user.uid}');
      print('name: ${user.displayName}');
      print('uid: ${user.email}');
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future logout() => _googleSignIn.disconnect();
}
