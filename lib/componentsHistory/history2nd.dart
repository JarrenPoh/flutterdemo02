import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import '../models/ColorSettings.dart';

class history2nd extends StatefulWidget {
  history2nd({
    Key? key,
    required this.describes,
    required this.name,
    required this.price,
    required this.options,
    required this.counts,
  }) : super(key: key);
  String describes, name;
  int price;
  int counts;
  List options;

  @override
  State<history2nd> createState() => _history2ndState(
      options: options, describes: describes, name: name, price: price,counts:counts);
}

class _history2ndState extends State<history2nd> {
  _history2ndState({
    required this.options,
    required this.describes,
    required this.name,
    required this.price,
    required this.counts,
  });
  String describes, name;
  int price;
  int counts;
  List options;
  String optionsString = '';
  @override
  void initState() {
    super.initState();

    ///檢查options裡面是list是string，都變成string
    List optionsList = [];
    for (var i = 0; i < options.length; i++) {
      if (options[i]['option'].runtimeType == List) {
        List fdfd = options[i]['option'];
        String fsfdd = fdfd.join(',');
        optionsList.add(fsfdd);
      } else if (options[i]['option'].runtimeType == String) {
        optionsList.add(options[i]['option']);
      }
    }
    optionsString = optionsList.join(',');
    print('optionsString is ${optionsString}');
    ///////
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BetweenSM(
                color: kBodyTextColor, text: 'x$counts', fontFamily: 'NotoSansMedium'),
            SizedBox(
              width: Dimensions.width20,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabText(
                    color: kBodyTextColor,
                    text: name,
                    fontFamily: 'NotoSansRegular',
                    maxLines: 10,
                  ),
                  TabText(
                    color: kTextLightColor,
                    text: optionsString,
                    fontFamily: 'NotoSansRegular',
                    maxLines: 30,
                  ),
                  TabText(
                    color: kTextLightColor,
                    text: describes,
                    fontFamily: 'NotoSansRegular',
                    maxLines: 30,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(children: const []),
            ),
            TabText(
              color: kBodyTextColor,
              text: '\$ ${widget.price}',
              fontFamily: 'NotoSansRegular',
            ),
          ],
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
      ],
    );
  }
}
