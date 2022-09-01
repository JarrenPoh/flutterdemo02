// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutterdemo02/API/getTokenApi.dart';
// import 'package:flutterdemo02/models/ColorSettings.dart';

// import '../provider/Shared_Preference.dart';

// class Login2Page extends StatefulWidget {
//   Map? arguments;
//   Login2Page({Key? key, this.arguments}) : super(key: key);

//   @override
//   State<Login2Page> createState() => Login2PageState(arguments: arguments);
// }

// class Login2PageState extends State<Login2Page> {
//   Map? arguments;
//   String refresh_token = UserSimplePreferences.getRefreshToken()!;
//   Login2PageState({this.arguments});

//   void startTimer() {
//     Timer(Duration(seconds: 2), () async {
//       var getToken = await getTokenApi.getToken(refresh_token);
//       Navigator.pushReplacementNamed(context, '/form3', arguments: {
//         'token': getToken.headers['token'],
//       });
//     });
//   }

//   @override
//   void initState() {
//     // print('refresh_token');
//     // print(UserSimplePreferences.getRefreshToken());
//     super.initState();
//     startTimer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: kMaim3Color,
//       ),
//     );
//   }
// }
