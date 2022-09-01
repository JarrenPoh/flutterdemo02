import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo02/components3/Drawer.dart';
import 'package:flutterdemo02/pages/Email.dart';
import 'package:flutterdemo02/pages/Form5.dart';
import 'package:flutterdemo02/pages/History2Order.dart';
import 'package:flutterdemo02/pages/MapSplash.dart';
import 'package:flutterdemo02/pages/SearchingPage.dart';
import 'package:flutterdemo02/pages/SplashScreen.dart';
import 'package:flutterdemo02/pages/UserCorrect.dart';
import 'package:flutterdemo02/pages/UserProfile.dart';
import 'package:flutterdemo02/pages/order_successful.dart';

import '../componentsShopcar/emptyshopCar.dart';

import '../pages/Form3.dart';
import '../pages/Form4.dart';
import '../pages/Form5.dart';

import '../pages/GoogleMap.dart';
import '../pages/GoogleMaps.dart';
import '../pages/HistoryOrder.dart';
import '../pages/Tabs.dart';

import '../pages/login2.dart';
import '../pages/tabs/BookMarkPage.dart';
// import '../pages/tabs/MyHome.dart';
import '../pages/ShopCar.dart';

import '../pages/user/RegisterFirst.dart';
import '../pages/user/RegisterSecond.dart';
import '../pages/user/RegisterThird.dart';
import '../pages/login.dart';

//配置路由
final routes = {
  '/tab': (context) => const Tabs(),
  '/form5': (context, {arguments}) => FormPage5(
        arguments: arguments,
      ),
  '/history': (
    context,
  ) =>
      HistoryPage(),
  '/history2': (context, {arguments}) => HistoryPage2(
        arguments: arguments,
      ),
  '/userprofile': (context) => UserProfile(),
  '/usercorrect': (context, {arguments}) => UserCorrect(
        arguments: arguments,
      ),

  '/form4': (context, {arguments}) => FormPage4(
        arguments: arguments,
      ),
  '/form3': (context, {arguments}) => FormPage3(),
  '/ordersuccessful': (context, {arguments}) => orderSuccessful(),

  '/searchingpage': (context, {arguments}) => SearchingPage(),

  '/registerfirst': (context) => const RegisterFirstPage(),
  '/registersecond': (context) => const RegisterSecondPage(),
  '/registerthird': (context) => const RegisterThirdPage(),
  '/appbardemo': (context) => AppBarDemoPage(),
  '/email': (context) => Email(),

  // '/myhome':(context)=>MyHomePage(),
  '/splash': (context) => SplashScreen(),
  '/login': (context) => const LoginPage(),
  '/mapsplash': (context, {arguments}) =>  MapSplash(arguments: arguments,),
  '/googlemap': (context, {arguments}) =>  googleMap(arguments: arguments,),
  // '/login2':(context,{arguments})=> Login2Page(arguments: arguments),
  '/shopcar': (context, {arguments}) => shopCar(
        arguments: arguments,
      ),
  '/emptyshopcar': (context) => const emptyShopCar(),
  '/bookmark': (context, {arguments}) => BookMarkPage(
        arguments: arguments,
      ),
};

class AppBarDemoPage {}

//固定寫法
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return null;
};
