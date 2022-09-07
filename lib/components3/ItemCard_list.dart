import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/groupModel.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/res/listData.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../res/listData.dart';
import 'Item_card.dart';

class ItemList extends StatefulWidget {
  ItemList({Key? key, required this.group}) : super(key: key);
  List<Result2?>? group;
  @override
  State<ItemList> createState() => _ItemListState(group: group);
}

class _ItemListState extends State<ItemList> {
  _ItemListState({required this.group});
  List<Result2?>? group;
  @override
  PageController pageController = PageController(viewportFraction: 0.85);
  var currPageValue = 0.0;

  @override
  void initState() {
    print('group is ${group?.length}');
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      setState(() {
        currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.removeListener(() {
      setState(() {
        currPageValue = pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.form3ItemCard,
                    child: PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: group!.length,
                      itemBuilder: ((context, index) {
                        return ItemCard(
                          index: index,
                          pageController: pageController,
                          currPageValue: currPageValue,
                          title: group![index]!.address!,
                          image: demoBigImages2[index]['image'],
                          shopName: group![index]!.name!,
                          press: () {},
                        );
                      }),
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: group!.length,
                    position: currPageValue,
                    decorator: DotsDecorator(
                      activeColor: kMaimColor,
                      color: kMaim3Color,
                      size: const Size.square(10.0),
                      activeSize: const Size(20.0, 10.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
