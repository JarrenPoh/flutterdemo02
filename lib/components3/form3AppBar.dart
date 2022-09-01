import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/BigText.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import '../pages/numberCard.dart';

class form3AppBar extends StatelessWidget with PreferredSizeWidget {
  const form3AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "中原大學".toUpperCase(),
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: kTextLightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
            ),
            Container(
              child: Image.asset(
                'images/foodone_page-0001_4-removebg-preview.png',
                width: MediaQuery.of(context).size.width / 3.26,
                height: MediaQuery.of(context).size.height / 27.5,
              ),
            ),
          ],
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          padding: EdgeInsets.only(left: Dimensions.width10),
          icon: Icon(
            Icons.sort,
            size: Dimensions.icon25,
          ),
          color: kMaimColor,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.only(right: Dimensions.width15),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return numberCard();
              },
            );
          },
          icon: Icon(Icons.lightbulb_outline_rounded, size: Dimensions.icon25),
          color: kMaimColor,
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
