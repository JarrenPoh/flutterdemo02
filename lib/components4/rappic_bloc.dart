import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

// import '../API/MenuModel.dart';
import '../API/MenuModel.dart';
import 'ShopProfile.dart';

class RappiBLoC with ChangeNotifier {
  List<RappiTabCategory> tabs = [];
  List<RappiItem> items = [];
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  bool _listen = true;
  final profilekey = GlobalKey<ShopProfileState>();
  double profileHeight = 0;
  // void getHeight() {
  //   final BuildContext? context = profilekey.currentContext;
  //   profileHeight = context!.size!.height;
  //   print(profileHeight);
  // }

  void init(SingleTickerProviderStateMixin ticker, double profileHeight,
      List<List<Result>> data2, List typeArray) async {
    // profileHeight = profilekey.currentContext!.size!.height;

    tabController = TabController(vsync: ticker, length: data2.length);

    double offsetFrom = 0.0;
    double offsetTo = 0.0;

    for (int i = 0; i < data2.length; i++) {
      // final category = rappiCategories[i];

      if (i > 0) {
        offsetFrom += data2[i - 1].length * productHeight;
      }

      if (i < data2.length - 1) {
        offsetTo = offsetFrom +
            data2[i].length * productHeight +
            categoryHeight * (i + 1);
      } else {
        offsetTo = double.infinity;
      }

      tabs.add(RappiTabCategory(
          category: typeArray[i],
          selected: (i == 0),
          //From是開頭的y
          offsetFrom: Dimensions.screenHeigt / 7.5 +
              categoryHeight * i +
              offsetFrom +
              Dimensions
                  .height20, //appBar(140) + i個標籤的長度 + i個商品組的高度 + 後來加了divider(15)  =>  這會讓跳轉到divider上方，所以這裡減掉
          //To是下一個開頭的y
          offsetTo: Dimensions.screenHeigt / 7.5 + offsetTo)); //appbar(140) +
      items.add(RappiItem(category: typeArray[i]));
      for (int j = 0; j < data2[i].length; j++) {
        final product = data2[i][j];
        items.add(RappiItem(product: product));
      }
    }
  }

  //滑到下面的哪個 標籤就自動換
  void onScrollListener() {
    final BuildContext? context = profilekey.currentContext;
    profileHeight = context!.size!.height;
    if (_listen) {
      for (int i = 0; i < tabs.length; i++) {
        final tab = tabs[i];

        if (scrollController.offset >= tab.offsetFrom + profileHeight &&
            scrollController.offset <= tab.offsetTo + profileHeight &&
            !tab.selected) {
          onCategorySelected(i, animationRequired: false);
          tabController.animateTo(i,
              duration: const Duration(milliseconds: 500));

          break;
        }
      }
    }
  }

  //點了for循環出來的哪個index，哪個index就是被選中的那個
  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    final BuildContext? context = profilekey.currentContext;
    profileHeight = context!.size!.height;
    for (int i = 0; i < tabs.length; i++) {
      final condition = selected == tabs[i];
      // print(condition);
      tabs[i] = tabs[i].copyWith(condition);
    }
    notifyListeners();

    if (animationRequired) {
      _listen = false;
      await scrollController.animateTo(
        selected.offsetFrom + profileHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      _listen = true;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(onScrollListener);
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

class RappiTabCategory {
  const RappiTabCategory({
    required this.category,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  RappiTabCategory copyWith(bool selected) => RappiTabCategory(
        category: category,
        selected: selected,
        offsetFrom: offsetFrom,
        offsetTo: offsetTo,
      );

  final category;
  final bool selected;
  //主動按的時候跳的
  final double offsetFrom;
  final double offsetTo;
}

class RappiItem {
  const RappiItem({
    this.category,
    this.product,
  });
  final category;
  final Result? product;
  bool get isCategory => category != null;
  bool get isProduct => product != null;
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
    // TODO: implement shouldRebuild
    return true;
  }
}
