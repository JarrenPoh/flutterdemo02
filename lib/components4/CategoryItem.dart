import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BigText.dart';

import '../models/ColorSettings.dart';

class RappiCategoryItem extends StatelessWidget {
  const RappiCategoryItem(this.category);
  final category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: categoryHeight,
      child: Column(
        children: [
          Divider(
            thickness: Dimensions.height15,
            color: kBottomColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: Dimensions.width15),
            alignment: Alignment.centerLeft,
            child: BigText(
              color: kBodyTextColor,
              text: category,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
