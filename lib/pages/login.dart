import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterdemo02/pages/SplashScreen.dart';
import 'package:http/http.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/loginApi.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../API/oneSignalApi.dart';
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
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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
    GoogleSignIn().signIn().then((result) {
      result!.authentication.then((googleKey) async {
        print('googleKey.accessToken is ${googleKey.accessToken}');
        String? key = googleKey.accessToken;
        await UserSimplePreferences.setGoogleKey(key!);
        print('object1');
        var users =
            await loginApi.getGoogleUsers(UserSimplePreferences.GetGoogleKey());
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

        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
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
      final user = await authService.signInWithApple(
        scopes: [
          Scope.email,
          Scope.fullName,
        ],
      );

      setState(() {
        isLoading = true;
      });
      //去登陸
      Response? login = await loginApi.getAppleUsers(
        user.email,
        user.uid,
      );
      setState(() {
        isLoading = false;
      });

      //登陸發生錯誤
      if (login?.statusCode == 400) {
        String registerName = '';
        if (user.displayName == null) {
          //讓使用者輸入姓名
          registerName = (await showDeleteDialod())!;
        } else {
          registerName = user.displayName!;
        }

        setState(() {
          isLoading = true;
        });
        Response? register = await loginApi.registerAppleUsers(
          registerName,
          user.email,
          user.uid,
        );
        login = await loginApi.getAppleUsers(
          user.email,
          user.uid,
        );
      }

      //設定資料
      await UserSimplePreferences.setRefreshToken(
          login!.headers['refresh_token']!);
      print('object3');
      Map list = jsonDecode(login.body);
      await UserSimplePreferences.setUserInformation(
        list['result']['email'],
        list['result']['name'],
        list['result']['picture'] ?? '',
      );
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  Future<String?> showDeleteDialod() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('第一次登入，幫自己取個名字吧'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                String name = _nameController.text;
                // 在这里处理用户输入的姓名
                Navigator.of(context).pop(name); // 关闭对话框并返回用户输入的姓名
              },
            ),
          ],
        );
      },
    );
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future logout() => _googleSignIn.disconnect();
}
