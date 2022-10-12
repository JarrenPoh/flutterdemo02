import 'package:flutter/material.dart';

import '../models/ColorSettings.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String text;
  final String hintText;
  const SearchWidget({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: Dimensions.height50 - Dimensions.height5,
      margin: EdgeInsets.symmetric(vertical: Dimensions.height15),
      padding: EdgeInsets.only(
          left: Dimensions.width15 / 2, right: Dimensions.width15 / 2, top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: TextField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.search_outlined,
            color: style.color,
            size: Dimensions.icon25,
          ),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: kMaimColor,
                    size: Dimensions.icon25,
                  ),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus();
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
        ),
        onChanged: widget.onChanged,
        style: style,
      ),
    );
  }
}
