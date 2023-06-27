import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

class shopcarAppBar extends StatelessWidget with PreferredSizeWidget {
  shopcarAppBar({Key? key}) : super(key: key);
  final CartController cartController = Get.find();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiddleText(
            color: kBodyTextColor,
            text: '購物車',
            fontFamily: 'NotoSansMedium',
          ),
          if (cartController.cartlist.isNotEmpty)
            TabText(
              color: kTextLightColor,
              text: cartController.cartlist.first.shopname,
            )
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left_outlined,
          color: kMaimColor,
          size: Dimensions.icon32,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 2,
      automaticallyImplyLeading: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
