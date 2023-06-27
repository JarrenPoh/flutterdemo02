import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo02/API/form4Api.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:flutterdemo02/components4/ShopProfile.dart';
import 'package:flutterdemo02/components4/rappic_bloc.dart';
import 'package:flutterdemo02/componentsShopcar/emptyshopCar.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/pages/ShopCar.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';
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
    // _bloc.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

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
                      print('${data[i].type}');
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
                    int selectedDay;
                    if (DateTime.now().weekday == 7) {
                      selectedDay = 0;
                    } else {
                      selectedDay = DateTime.now().weekday;
                    }

                    if (data3.businessTime?[selectedHour][selectedDay] ==
                            true ||
                        data3.status! <= 180) {
                      print('22營業中');
                      businessTime = true;
                    } else {
                      print('22尚未營業');
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
                                          CachedNetworkImage(
                                            imageUrl:
                                                'https://foodone-s3.s3.amazonaws.com/store/main/${arguments['id']}?${data3.last_update}',
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              width: Dimensions.screenWidth,
                                              height:
                                                  Dimensions.screenHeigt / 4.85,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  bottom: Radius.elliptical(
                                                    Dimensions.screenWidth,
                                                    30,
                                                  ),
                                                ),
                                                color: Colors.grey,
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                    'images/preImage.jpg',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    Container(
                                              width: Dimensions.screenWidth,
                                              height:
                                                  Dimensions.screenHeigt / 4.85,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  bottom: Radius.elliptical(
                                                    Dimensions.screenWidth,
                                                    30,
                                                  ),
                                                ),
                                                color: Colors.grey,
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                    'images/preImage.jpg',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: Dimensions.screenWidth,
                                              height:
                                                  Dimensions.screenHeigt / 4.85,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  bottom: Radius.elliptical(
                                                    Dimensions.screenWidth,
                                                    30,
                                                  ),
                                                ),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
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
                                          Navigator.push(
                                            context,
                                            CustomPageRoute(
                                              child: emptyShopCar(),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            CustomPageRoute(
                                              child: shopCar(
                                                arguments: {
                                                  'shopname': data3.name,
                                                  'shopimage': data3.image,
                                                  // 'delivertime':
                                                  //     arguments['delivertime'],
                                                  'businessTime':
                                                      data3.businessTime,
                                                  'status': data3.status,
                                                },
                                              ),
                                            ),
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
                                  ),
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
                                                  data3.last_update!,
                                                  data3.thumbnail!,
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
