import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

class MiddleText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  FontWeight? weight;
  String fontFamily;
  TextOverflow overFlow;
  int maxlines;
  MiddleText(
      {Key? key,
      required this.color,
      required this.text,
      this.maxlines = 1,
      this.fontFamily = 'NotoSansLight',
      this.size = 18,
      this.weight = FontWeight.w100,
      this.overFlow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines,
      overflow: overFlow,
      style: TextStyle(
          fontSize: Dimensions.fontsize18,
          color: color,
          fontWeight: weight,
          fontFamily: fontFamily),
    );
  }
}
