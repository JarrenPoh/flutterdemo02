// ignore_for_file: prefer_const_constructors, duplicate_ignore, file_names
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/pages/Form3.dart';
import 'package:flutterdemo02/pages/Form4.dart';
import 'package:flutterdemo02/pages/SplashScreen.dart';
import 'package:flutterdemo02/pages/login.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:flutterdemo02/provider/googleMapKey.dart';
import 'package:flutterdemo02/provider/local_notification_service.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API/oneSignalApi.dart';
import 'routes/Routes.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutterdemo02/provider/globals.dart' as globals;
import 'package:flutterdemo02/provider/authentication_viewmodel.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppleSignInAvailable.check();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await UserSimplePreferences.init();

  runApp(ProviderScope(child: MyApp()));

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  await OneSignal.shared.setAppId(OnesignalAppID);

  await OneSignal.shared
      .promptUserForPushNotificationPermission()
      .then((accept) => print('accept permision $accept'));
  var appid;
  OneSignal.shared.getDeviceState().then((value) async{
    appid = value!.userId!;
    print('userid2 is $appid');
    if (appid != null || appid != UserSimplePreferences.getOneSignalAppID()) {
      print('object0');
      await UserSimplePreferences.setOneSignalAppID(appid);
      await UserSimplePreferences.setOneSignalApiDone(false);
      print('object1');
      if (UserSimplePreferences.getOneSignalApiDone() != true &&
          UserSimplePreferences.getOneSignalAppID() != null &&
          UserSimplePreferences.getToken() != null) {
        await OneSignalapi.getOneSignal(UserSimplePreferences.getOneSignalAppID()!,
            UserSimplePreferences.getToken());
        debugPrint(
          '這台手機尚未訂閱oneSinal帳號或手機裝置不同, 完成為 ${UserSimplePreferences.getOneSignalApiDone()}',
        );
      }
    }
  });
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
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
          appBarTheme: AppBarTheme(
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            iconColor: kMaimColor,
          ),
          errorColor: kMaimColor,
          indicatorColor: kMaimColor,
        ),
        navigatorKey: globals.appNavigator,
        localizationsDelegates: const [],
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        initialRoute: '/splash', //初始化的時候要加載哪個路由
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
