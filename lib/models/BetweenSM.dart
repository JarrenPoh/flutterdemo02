import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';

class BetweenSM extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  FontWeight? weight;
  String fontFamily;
  TextOverflow overFlow;
  int maxLines;

  BetweenSM(
      {Key? key,
      required this.color,
      required this.text,
      this.fontFamily = 'NotoSansRegular',
      this.size = 16,
      this.maxLines = 1,
      this.weight = FontWeight.w100,
      this.overFlow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overFlow,
      style: TextStyle(
        fontSize: Dimensions.fontsize16,
        color: color,
        fontWeight: weight,
        fontFamily: fontFamily,
      ),
    );
  }
}
