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
import 'package:flutterdemo02/provider/local_notification_service.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API/oneSignalApi.dart';
import 'routes/Routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutterdemo02/provider/globals.dart' as globals;

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

  globals.appNavigator = GlobalKey<NavigatorState>();
  globals.globalToForm4 = GlobalKey<FormPage4State>();

  runApp(ProviderScope(child: MyApp()));
  late final LocalNotificationService service;
  service = LocalNotificationService();
  service.intialize();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  await OneSignal.shared.setAppId("ec271f5c-c5ee-4465-8f82-9e5be14bd308");

  // OneSignal.shared
  //     .promptUserForPushNotificationPermission()
  //     .then((accept) => print('accept permision $accept'));
  var appid;
  await OneSignal.shared.getDeviceState().then((value) {
    appid = value!.userId!;
    UserSimplePreferences.setOneSignalAppID(appid);
  });

  var onesignal;
  Future spectator() async {
    onesignal = OneSignalapi.getOneSignal(
        UserSimplePreferences.getOneSignalAppID()!,
        UserSimplePreferences.getToken());
    return await onesignal;
  }

  Future inspect() async {
    var ss = await spectator();
    if (ss == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      onesignal = OneSignalapi.getOneSignal(
        UserSimplePreferences.getOneSignalAppID()!,
        UserSimplePreferences.getToken(),
      );
    }
  }

  await inspect();

  // OneSignal.shared.pauseInAppMessages(true);
  void listenToNotification() => service.onNotificationClick.stream.listen(
        (payload) {
          if (payload != null) {
            // globals.appNavigator?.currentState?.push(
            //   MaterialPageRoute(
            //     builder: (context) => LoginPage(),
            //   ),
            // );
            globals.globalToForm4?.currentState?.inspect();
          }
        },
      );

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
        event.complete(event.notification);
    print('FOREGROUND HANDLER CALLED WITH: ${event}');
    //  /// Display Notification, send null to not display
    print('看這這這這看這這這這看這這這這看這這這這${event.notification.title}');
    print('看這這這這看這這這這看這這這這看這這這這${event.notification.body}');
    print('看這這這這看這這這這看這這這這看這這這這${event.notification.subtitle}');
    listenToNotification();
    service.showNotificationWithPayload(
      id: 0,
      title: event.notification.title!,
      body: event.notification.body!,
      payload: '',
    );
  });
  

// OneSignal.shared.setInAppMessageClickedHandler((action) {action.clickName;});
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
          bottomSheetTheme:BottomSheetThemeData(backgroundColor:Colors.transparent ) ,
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
