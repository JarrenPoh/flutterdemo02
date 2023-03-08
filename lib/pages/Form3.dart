import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/BigText.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/pages/MapSplash.dart';
import 'package:flutterdemo02/pages/numberCard.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';
import 'package:flutterdemo02/provider/local_notification_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutterdemo02/components3/Main_shopList.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:flutterdemo02/res/listData.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:url_launcher/link.dart';

import '../API/StoreModel.dart';
import '../API/form3Api.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../API/groupModel.dart';
import '../components3/ItemCard_list.dart';
import '../components3/Drawer.dart';
import '../components3/SliverAppBar.dart';
import '../components3/form3AppBar.dart';
import 'package:flutterdemo02/provider/globals.dart' as globals;

import 'numberCarSecond.dart';

class FormPage3 extends StatefulWidget {
  FormPage3({
    Key? key,
  }) : super(key: key);

  @override
  State<FormPage3> createState() => FormPage3State();
}

class FormPage3State extends State<FormPage3> with TickerProviderStateMixin {
  late TabController _tabController;
  PageController pageController = PageController(viewportFraction: 0.85);

  late Future<List<Result?>?>? stores;
  List<Result2?>? SS = [];
  bool ok = false;
  List<Result2?>? group = [];
  Map body = {};

  //////
  void oneSignalInit() {
    globals.appNavigator = GlobalKey<NavigatorState>();
    globals.globalToNumCard2 = GlobalKey<numberCardSecondState>();
    globals.globalToNumCard = GlobalKey<numberCardState>();
    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      print('openedResult.action!.type; is ${openedResult.action!.type}');

      await globals.appNavigator?.currentState?.push(
        MaterialPageRoute(
          builder: (context) => numberCardSecond(
            arguments: {},
          ),
        ),
      );
      print('navigator to orderCard2 is successful');

      await globals.globalToNumCard2?.currentState?.inspect2();
      print('start numCard2 inspect2 is successful');

      await globals.globalToNumCard?.currentState?.inspect();
      print('start numCard inspect2 is successful');
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) async {
        event.complete(event.notification);
        print('FOREGROUND HANDLER CALLED WITH: ${event}');
        //  /// Display Notification, send null to not display

        await globals.globalToNumCard2?.currentState?.inspect2();
        print('start numCard2 inspect2 is successful');

        await globals.globalToNumCard?.currentState?.inspect();
        print('start numCard inspect2 is successful');
      },
    );
  }

  Future inspect() async {
    var ss = await spectator();
    SS = await spectator2(UserSimplePreferences.getToken());
    if (ss == null || SS == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      ss = await spectator();
      SS = await spectator2(UserSimplePreferences.getToken());
      setState(() {
        ok = true;
      });
    } else if (ss != null || SS != null) {
      setState(() {
        ok = true;
      });
    }

    return SS;
  }

  Future spectator() async {
    stores = BooksApi.getStores(UserSimplePreferences.getToken());
    return await stores;
  }

  spectator2(key) async {
    var response = await http.get(
      Uri.parse("https://www.foodone.tw/member/ad"),
      headers: {
        "token": key,
        "Content-Type": "application/x-www-form-urlencoded",
        "id": "62ce7094d47de10b3b6d68f7",
      },
    );
    debugPrint('statuscode of groupApi in Form3 is ${response.statusCode}');
    debugPrint('statusbody of groupApi in Form3 is ${response.body}');
    if (response.statusCode == 200) {
      var obj = Autogenerated.fromJson(jsonDecode(response.body));
      var groups = (obj.result as List<Result2?>);
      print('the response body of groupApi in Form3 is $groups');
      debugPrint('status200 of groupApi in Form3');
      return groups;
    } else if (response.statusCode == 403) {
      debugPrint('status403 of groupApi in Form3');
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }

  late List<List<Result>> data2 = [];
  ///////

  @override
  void initState() {
    super.initState();
    inspect().then(
      (value) {
        if (SS != null) {
          if (mounted) {}
        }
      },
    );
    oneSignalInit();
  }

/////更新如果一樣就不用申請                   完成
/////購物籃存硬碟                            不能因為我不會更新
/////送出船api                               完成
/////船api後清除所有事情 cartcontroler tableWare usersimple totalPrice orderPreview   好像完成
/////送出那個畫面琳筠安  成功and失敗
/////拿號碼牌 floatingActionButton
/////廣告                                    完成
/////廣告超連結
/////歷史訂單                                完成
/////折扣單form3 clearALL                    完成
/////form3 place 標籤                        完成
/////訂單傳取餐時間
/////api拿未完成訂單
/////電話驗證                                完成
/////驗證完才能送訂單                         完成
/////googleMap
/////notification
/////firebase
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: BetweenSM(
            color: kBodyTextColor, text: '退出按確定', fontFamily: 'NotoSansBold'),
        content: TabText(color: kBodyTextColor, text: '你確定要退出嗎，點擊確認立即退出'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: TabText(
              color: Colors.blue,
              text: '取消',
              fontFamily: 'NotoSansBold',
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: TabText(
                color: Colors.blue, text: '確定', fontFamily: 'NotoSansBold'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, //ios icon white
        statusBarIconBrightness: Brightness.light, //android icon white
        // statusBarColor: Colors.red  //android backgroungColor
      ),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          body: Container(
            color: kMaim3Color,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                drawer: NavigationDrawer(),
                appBar: const form3AppBar(),
                body: ok == true
                    ? FutureBuilder<List<Result?>?>(
                        future: stores,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            List<Result> data = snapshot.data;
                            var typeSet = <String>{};
                            print('object2');
                            print(data.length);

                            for (var i = 0; i < data.length; i++) {
                              if (data[i].place != null) {
                                typeSet.add(data[i].place!);
                              } else {
                                data[i].place = '其它';
                                typeSet.add(data[i].place!);
                              }
                            }
                            final List<String> typeArray = typeSet.toList();
                            for (var i = 0; i < typeArray.length; i++) {
                              // data2.add(typeArray[i]);
                              data2.add(
                                data
                                    .where((product) =>
                                        product.place!.contains(typeArray[i]))
                                    .toList(),
                              );
                            }

                            _tabController = TabController(
                              length: typeArray.length,
                              vsync: this,
                            );

                            return NestedScrollView(
                              headerSliverBuilder:
                                  (context, innerBoxIsScrolled) {
                                return <Widget>[
                                  SliverappbarForP3(),
                                  SliverPadding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.width15),
                                    sliver: SliverToBoxAdapter(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                MiddleText(
                                                  text: '公告',
                                                  color: kBodyTextColor,
                                                  fontFamily: 'NotoSansMedium',
                                                ),
                                                TabText(
                                                  color: kMaimColor,
                                                  text: '右滑',
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: Dimensions.height10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: ItemList(
                                      BodyCallBack: (value) {
                                        setState(() {
                                          body = value;
                                        });
                                      },
                                      group: SS,
                                      press: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) => buildSheet(),
                                        );
                                      },
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.width15),
                                    sliver: SliverToBoxAdapter(
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                MiddleText(
                                                  text: '所有餐廳',
                                                  color: kBodyTextColor,
                                                  fontFamily: 'NotoSansMedium',
                                                ),
                                                IconButton(
                                                  iconSize: 32,
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: ((context) =>
                                                            FormPage3()),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.refresh,
                                                    color: kMaimColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SliverPersistentHeader(
                                    pinned: true,
                                    delegate: MySliverDelegate(
                                      minHeight: Dimensions.height50,
                                      maxHeight: Dimensions.height50,
                                      child: Container(
                                        color: Colors.white,
                                        child: TabBar(
                                          controller: _tabController,
                                          isScrollable: true,
                                          labelColor: kMaimColor,
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: Dimensions.fontsize14),
                                          unselectedLabelColor: kTextLightColor,
                                          unselectedLabelStyle:
                                              const TextStyle(fontSize: 13),
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          indicatorColor: kMaimColor,
                                          indicator: MaterialIndicator(
                                            height: Dimensions.height15 / 5,
                                            color: kMaimColor,
                                            topLeftRadius: 5,
                                            topRightRadius: 5,
                                            bottomLeftRadius: 5,
                                            bottomRightRadius: 5,
                                          ),
                                          indicatorPadding: EdgeInsets.only(
                                              bottom: Dimensions.height15 / 2,
                                              left: Dimensions.width15,
                                              right: Dimensions.width15),
                                          tabs: List.generate(
                                            typeArray.length,
                                            (index) => Tab(
                                              child: Text(
                                                typeArray[index],
                                                style: const TextStyle(
                                                  fontFamily: 'NotoSansMedium',
                                                ),
                                              ),
                                            ),
                                          ),
                                          //點擊就將index傳到上面scrollTo的index
                                        ),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              body: TabBarView(
                                controller: _tabController,
                                children: List.generate(
                                  typeArray.length,
                                  (index) {
                                    return mainList(
                                      data: data2[index],
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Center(child: CircularProgressIndicator()),
                floatingActionButton: FabCircularMenu(
                  alignment: Alignment.bottomRight,
                  // fabChild: Container(
                  //   child: Image.asset('images/foodone_logo_pink_1000.png',fit: BoxFit.cover,),
                  // ),
                  fabColor: Colors.blue.shade50,
                  fabOpenColor: Colors.red.shade100,
                  ringDiameter: 250.0,
                  ringWidth: 60.0,
                  ringColor: Colors.blue.shade50,
                  fabSize: 60.0,
                  animationDuration: Duration(milliseconds: 400),
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return numberCard();
                          },
                        );
                      },
                      child: Container(
                        width: Dimensions.width20,
                        height: Dimensions.height20 * 2 + Dimensions.height10,
                        child: Image.asset(
                          'images/number2.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        minimumSize: Size(15, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3000.0),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        LocationData? currentLocation;
                        Location location = Location();
                        bool _serviceEnabled;
                        PermissionStatus _permissionGranted;

                        _serviceEnabled = await location.serviceEnabled();
                        if (!_serviceEnabled) {
                          _serviceEnabled = await location.requestService();
                          if (!_serviceEnabled) {
                            return;
                          }
                        }

                        _permissionGranted = await location.hasPermission();
                        if (_permissionGranted == PermissionStatus.denied) {
                          _permissionGranted =
                              await location.requestPermission();
                          if (_permissionGranted != PermissionStatus.granted) {
                            return;
                          }
                        }

                        await location.getLocation().then((location) {
                          currentLocation = location;
                          Navigator.push(
                            context,
                            CustomPageRoute(
                              child: MapSplash(
                                arguments: {
                                  'currentLocation': currentLocation,
                                },
                              ),
                            ),
                          );
                        });
                        print('currentLocation');
                      },
                      child: Container(
                        width: Dimensions.width20,
                        height: Dimensions.height20 * 2 + Dimensions.height10,
                        child: Image.asset(
                          'images/google-maps.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          minimumSize: Size(15, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3000.0))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet() => makeDismissible(
        child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) =>
              Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.radius20),
              ),
            ),
            padding: EdgeInsets.all(Dimensions.height20),
            child: ListView(
              controller: scrollController,
              children: [
                if (body['url'] != null || body['url'] != '')
                  Align(
                    alignment: Alignment.topRight,
                    child: Link(
                      target: LinkTarget.self,
                      uri: Uri.parse(body['url']),
                      builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: TabText(
                          color: kTextLightColor,
                          text: '詳情',
                          fontFamily: 'NotoSansMedium',
                        ),
                      ),
                    ),
                  ),
                BigText(
                  color: kBodyTextColor,
                  text: '    ' + body['title'],
                  fontFamily: 'NotoSansMedium',
                ),
                SizedBox(height: Dimensions.height15),
                if (body['image'] != null)
                  Container(
                    child: Image.network(
                      body['image']!,
                      fit: BoxFit.cover,
                    ),
                    height: Dimensions.screenHeigt / 4.85,
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                  ),
                if (body['image'] == null)
                  Container(
                    height: Dimensions.screenHeigt / 4.85,
                    width: Dimensions.screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          Dimensions.radius15,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: Dimensions.height15),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimensions.width10 / 2),
                  child: TabText(
                    color: kBodyTextColor,
                    text: body['subtitle'],
                    fontFamily: 'NotoSansMedium',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  MySliverDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //子Widget布局

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => (maxHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
