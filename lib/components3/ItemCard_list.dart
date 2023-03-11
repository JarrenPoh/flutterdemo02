import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/groupModel.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/res/listData.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../res/listData.dart';
import 'Item_card.dart';

class ItemList extends StatefulWidget {
  ItemList(
      {Key? key,
      required this.group,
      required this.press,
      required this.BodyCallBack})
      : super(key: key);
  List<Result2?>? group;
  ValueChanged BodyCallBack;
  Function() press;
  @override
  State<ItemList> createState() => _ItemListState(
        group: group,
        press: press,
        BodyCallBack: BodyCallBack,
      );
}

class _ItemListState extends State<ItemList> {
  _ItemListState(
      {required this.group, required this.press, required this.BodyCallBack});
  List<Result2?>? group;
  ValueChanged BodyCallBack;
  Function() press;
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
                        return GestureDetector(
                          onTap: () {
                            if(group![index]!.url!=null){
                              launchUrlString(group![index]!.url!);
                            }
                            
                            // press();
                            // BodyCallBack({
                            //   'subtitle': group![index]!.subtitle!,
                            //   'image': group![index]!.image,
                            //   'title': group![index]!.title!,
                            //   'url': group![index]!.url,
                            // });
                          
                          },
                          child: ItemCard(
                            index: index,
                            pageController: pageController,
                            currPageValue: currPageValue,
                            subtitle: group![index]!.subtitle!,
                            image: group![index]!.image,
                            title: group![index]!.title!,
                          ),
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
