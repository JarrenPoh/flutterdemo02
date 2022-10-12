import 'package:flutter/material.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/TabsText.dart';

class ItemCard extends StatelessWidget {
  final String title, shopName; //,image
  final String? image;
  var index = 0, currPageValue = 0.0;
  double height = Dimensions.form3ItemCardContainer;
  double secondHeight = Dimensions.form3ItemCardTextContainer;
  double scaleFactor = 0.75;
  PageController pageController;
  ItemCard({
    Key? key,
    required this.title,
    required this.index,
    required this.currPageValue,
    required this.image,
    required this.shopName,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height;
    double imageWidth = MediaQuery.of(context).size.width;

    Matrix4 matrix4 = Matrix4.identity();
    /////Transform
    if (index == currPageValue.floor()) {
      var currScale = 1 - (currPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currPageValue.floor() + 1) {
      var currScale =
          scaleFactor + (currPageValue - index + 1) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currPageValue.floor() - 1) {
      var currScale = 1 - (currPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.75;
      var currTrans = height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    }
    ////
    return Transform(
      transform: matrix4,
      child: Stack(
        children: [
          if (image != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width15),
              height: height,
              width: imageWidth,
              child: AspectRatio(
                aspectRatio: 1.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  child: Image.network(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (image == null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width15),
              height: height,
              width: imageWidth,
              child: AspectRatio(
                aspectRatio: 1.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  left: Dimensions.width15 * 3,
                  right: Dimensions.width15 * 3,
                  bottom: Dimensions.height10),
              padding: EdgeInsets.only(
                  top: Dimensions.height10,
                  left: Dimensions.width15,
                  right: Dimensions.width15),
              height: secondHeight,
              width: imageWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFe8e8e8),
                    blurRadius: 5.0,
                    offset: Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, 0),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(5, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabText(
                      text: shopName,
                      color: kBodyTextColor,
                      fontFamily: 'NotoSansMedium'),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  TabText(color: kTextLightColor, text: title)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
