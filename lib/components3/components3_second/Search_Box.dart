import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 19.6,
              vertical: MediaQuery.of(context).size.height / 164),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.height50),
            color: Colors.white,
            border: Border.all(color: kMaimColor.withOpacity(0.32)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_outlined,
                color: kMaimColor,
                size: Dimensions.icon25,
              ),
              SizedBox(
                width: Dimensions.width15,
              ),
              BetweenSM(color: Colors.black54, text: '輸入店家名稱或地址'),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
