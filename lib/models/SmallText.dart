import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  FontWeight? weight;
  TextOverflow overFlow;
  String fontFamily;
  SmallText(
      {Key? key,
      required this.color,
      required this.text,
      this.fontFamily = 'NotoSansMedium',
      this.size = 12,
      this.weight = FontWeight.w300,
      this.overFlow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: overFlow,
      style: TextStyle(
          fontSize: Dimensions.fontsize13,
          color: color,
          fontWeight: weight,
          fontFamily: fontFamily),
    );
  }
}
