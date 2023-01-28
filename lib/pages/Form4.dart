import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/form4Api.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:flutterdemo02/components4/ShopProfile.dart';
import 'package:flutterdemo02/components4/rappic_bloc.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/provider/globals.dart' as globals;
import 'package:get/get.dart';
import '../API/MenuModel.dart';
import '../components4/CategoryItem.dart';
import '../components4/ProductItem.dart';
import '../components4/TabCategory.dart';
import '../controllers/cart_controller.dart';
import '../models/BetweenSM.dart';
import '../models/TabsText.dart';
import '../provider/Shared_Preference.dart';

class FormPage4 extends StatefulWidget {
  Map arguments;
  FormPage4({Key? key, required this.arguments}) : super(key: key);

  @override
  State<FormPage4> createState() => FormPage4State(arguments: arguments);
}

class FormPage4State extends State<FormPage4>
    with SingleTickerProviderStateMixin {
  FormPage4State({
    required this.arguments,
  });
  Map arguments;
  late final _bloc = RappiBLoC();
  late Future<Result3?>? stores;
  double profileHeight = 0;
  void getHeight() {
    _bloc.scrollController.addListener(_bloc.onScrollListener);
  }

  late List<List<Result>> data2 = [];

  ////////////
  void inspect() async {
    var ss = await spectator();
    if (ss == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      stores =
          MenuApi.getMenus(arguments['id'], UserSimplePreferences.getToken());
      setState(() {});
    }
  }

  Future spectator() async {
    stores =
        MenuApi.getMenus(arguments['id'], UserSimplePreferences.getToken());
    return await stores;
  }

  bool? businessTime;
  ////////////
  @override
  void initState() {
    //項目選染完後計算後呼叫getHeight，這時候getHeigt才會addListener，此時listener已經有height了
    inspect();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getHeight());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getHeight());
    _bloc.profileHeight = 100;
    // _bloc.init(
    //   this,
    //   profileHeight,
    //   data2,
    // );

    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  final cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, //ios icon white
        statusBarIconBrightness: Brightness.light, //android icon white
        // statusBarColor: Colors.red  //android backgroungColor
      ),
      child: Scaffold(
        body: Container(
          color: kMaim3Color,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: FutureBuilder<Result3?>(
                future: stores,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    Result3 data3 = snapshot.data;
                    List<Result> data = data3.product!;
                    var typeSet = <String>{};
                    for (var i = 0; i < data.length; i++) {
                      typeSet.add(data[i].type);
                    }
                    final List<String> typeArray = typeSet.toList();

                    for (var i = 0; i < typeArray.length; i++) {
                      // data2.add(typeArray[i]);
                      data2.add(data
                          .where(
                              (product) => product.type.contains(typeArray[i]))
                          .toList());
                    }

                    int selectedHour = TimeOfDay.now().hour;
                    int selectedDay = DateTime.now().weekday;
                    print('here is $selectedDay');
                    if (data3.businessTime?[selectedHour][selectedDay] == true) {
                      print('營業中');
                      businessTime = true;
                    } else {
                      print('尚未營業');
                      businessTime = false;
                    }

                    _bloc.init(
                      this,
                      profileHeight,
                      data2,
                      typeArray,
                    );
                    return AnimatedBuilder(
                      animation: _bloc,
                      builder: (_, __) => Builder(
                        builder: (BuildContext context) {
                          return CustomScrollView(
                            controller: _bloc.scrollController,
                            slivers: <Widget>[
                              SliverAppBar(
                                expandedHeight: Dimensions.screenHeigt / 4.85,
                                pinned: true,
                                stretch: true,
                                elevation: 0,
                                flexibleSpace: LayoutBuilder(
                                  builder: ((context, constraints) {
                                    var top = constraints.biggest.height;
                                    return FlexibleSpaceBar(
                                      background: Column(
                                        children: [
                                          data3.image != null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      bottom: Radius.elliptical(
                                                        Dimensions.screenWidth,
                                                        30,
                                                      ),
                                                    ),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data3.image!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: Dimensions.screenWidth,
                                                  height:
                                                      Dimensions.screenHeigt /
                                                          4.85,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8UkVTVEFVUkFOVHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                                                        ),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      bottom: Radius.elliptical(
                                                        Dimensions.screenWidth,
                                                        30,
                                                      ),
                                                    ),
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                        ],
                                      ),
                                      title: AnimatedOpacity(
                                        opacity: top <=
                                                Dimensions.screenHeigt / 14.47
                                            ? 1.0
                                            : 0.0,
                                        duration:
                                            const Duration(milliseconds: 1),
                                        child: Row(
                                          children: [
                                            MiddleText(
                                              color: kBodyTextColor,
                                              text: data3.name!,
                                              fontFamily: 'NotoSansMedium',
                                            ),
                                          ],
                                        ),
                                      ),

                                      //在上升的時候背景圖片固定
                                      collapseMode: CollapseMode.pin,
                                      stretchModes: const <StretchMode>[
                                        StretchMode.blurBackground
                                      ],
                                    );
                                  }),
                                ),
                                leading: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Container(
                                    width: Dimensions.height20 * 1.6,
                                    height: Dimensions.height20 * 1.6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius20 * 2,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.chevron_left_outlined,
                                      color: kMaimColor,
                                      size: Dimensions.icon25 * 1.2,
                                    ),
                                  ),
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      if (UserSimplePreferences
                                              .getPhoneVerify() ==
                                          true) {
                                        if (cartController.cartlist.isEmpty) {
                                          Navigator.pushNamed(
                                              context, '/emptyshopcar');
                                        } else {
                                          Navigator.pushNamed(
                                            context,
                                            '/shopcar',
                                            arguments: {
                                              'shopname': data3.name,
                                              'shopimage': data3.image,
                                              // 'delivertime':
                                              //     arguments['delivertime'],
                                              'businessTime':
                                                  data3.businessTime,
                                            },
                                          );
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: kBottomColor,
                                              scrollable: true,
                                              title: BetweenSM(
                                                color: kBodyTextColor,
                                                text: '手機驗證尚未通過',
                                                fontFamily: 'NotoSansMedium',
                                                maxLines: 3,
                                              ),
                                              content: Column(
                                                children: [
                                                  TabText(
                                                    color: kBodyTextColor,
                                                    text:
                                                        '前往首頁->左上方資訊欄->個人檔案->手機號碼 進行驗證',
                                                    fontFamily:
                                                        'NotoSansMedium',
                                                    maxLines: 100,
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text('確認'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    icon: Container(
                                      width: Dimensions.height20 * 1.6,
                                      height: Dimensions.height20 * 1.6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20 * 2),
                                        color: Colors.white,
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: kMaimColor,
                                        size: Dimensions.icon25,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SliverToBoxAdapter(
                                child: ShopProfile(
                                  businessTime: businessTime!,
                                  data3: data3,
                                  key: _bloc.profilekey,
                                ),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: MySliverDelegate(
                                  maxHeight: Dimensions.height50,
                                  minHeight: Dimensions.height50,
                                  child: Container(
                                    height: Dimensions.height50,
                                    color: Colors.white,
                                    child: TabBar(
                                      onTap: _bloc.onCategorySelected,
                                      //
                                      controller: _bloc.tabController,
                                      //
                                      indicatorWeight: 0.01,
                                      isScrollable: true,
                                      tabs: _bloc.tabs
                                          .map((e) => RappidTabWidget(e))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    SingleChildScrollView(
                                      //

                                      //
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: List.generate(
                                            _bloc.items.length,
                                            (index) {
                                              final item = _bloc.items[index];
                                              if (item.isCategory) {
                                                return RappiCategoryItem(
                                                    item.category!);
                                              } else {
                                                return RappiProductItem(
                                                  item.product!,
                                                  data3,
                                                  businessTime!,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
