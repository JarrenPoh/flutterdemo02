import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  FontWeight? weight;
  int maxLines;
  TextOverflow overFlow;
  String fontFamily;
  BigText({
    Key? key,
    required this.color,
    required this.text,
    this.maxLines = 2,
    this.size = 22,
    this.weight = FontWeight.w100,
    this.overFlow = TextOverflow.ellipsis,
    this.fontFamily = 'NotoSansRegular',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overFlow,
      style: TextStyle(
        fontSize: Dimensions.fontsize24,
        color: color,
        fontWeight: weight,
        fontFamily: fontFamily,
      ),
    );
  }
}
