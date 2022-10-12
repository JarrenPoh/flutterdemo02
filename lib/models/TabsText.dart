import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

class TabText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  FontWeight? weight;
  int? maxLines;
  String fontFamily;
  TextAlign textAlign;
  TabText(
      {Key? key,
      required this.color,
      required this.text,
      this.textAlign = TextAlign.start,
      this.weight = FontWeight.w300,
      this.maxLines = 1,
      this.fontFamily = 'NotoSansRegular',
      this.size = 14,
      this.overFlow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overFlow,
      style: TextStyle(
        fontSize: Dimensions.fontsize14,
        color: color,
        fontWeight: weight,
        fontFamily: fontFamily,
      ),
    );
  }
}
