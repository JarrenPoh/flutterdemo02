// ignore_for_file: prefer_const_constructors, duplicate_ignore, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/pages/Form3.dart';
import 'package:flutterdemo02/pages/SplashScreen.dart';
import 'package:flutterdemo02/pages/login.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/Routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarBrightness: Brightness.dark, //ios icon white
  //   statusBarIconBrightness: Brightness.light, //android icon white
  //   // statusBarColor: Colors.red  //android backgroungColor
  // ));
  await UserSimplePreferences.init();
  runApp(ProviderScope(child: MyApp()));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    // ignore: todo
    // TODO: implement build
    return GetMaterialApp(
        // title: "FoodOne 中原大學",
        theme: ThemeData(
          unselectedWidgetColor: kMaimColor,
          primaryColor: kMaimColor,
          appBarTheme: AppBarTheme(
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            iconColor: kMaimColor,
          ),
          errorColor: kMaimColor,
          indicatorColor: kMaimColor,
        ),
        localizationsDelegates: const [],
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        initialRoute: '/try', //初始化的時候要加載哪個路由
        onGenerateRoute:
            onGenerateRoute //把Routes.dart裡面的onGenerateRoute附值給main.dart的ongenerateRoute
        );
  }

  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );
}
