import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import '../res/ListData3.dart';

class RequiredRadio extends StatefulWidget {
  RequiredRadio({
    Key? key,
    required this.lindex,
    required this.radioTitleList,
    required this.radioMultiple,
    required this.radiolist,
    required this.BoolCallBack,
    required this.radiobool,
    required this.arguments,
    required this.radioprices,
    required this.radiopricesnum,
    required this.NumCallBack,
    required this.requiredList,
    required this.requiredTitle,
    required this.multipleBool,
    required this.requiredCheckBool,
    required this.requiredCheckPrices,
    required this.max,
    required this.min,
  }) : super(key: key);
  final ValueChanged<bool> BoolCallBack;
  final ValueChanged<int> NumCallBack;
  List<String?> radioTitleList = [];
  List<bool?> radioMultiple = [];
  List<List> radiolist;
  int lindex;
  bool radiobool;
  Map arguments;
  List<int> radioprices;
  int radiopricesnum;
  List requiredList;
  String requiredTitle;
  bool multipleBool;
  List<List> requiredCheckBool;
  num requiredCheckPrices;
  String? max;
  String? min;

  @override
  State<RequiredRadio> createState() => _RequiredRadioState(
        lindex: lindex,
        radioTitleList: radioTitleList,
        radioMultiple: radioMultiple,
        radiolist: radiolist,
        BoolCallBack: BoolCallBack,
        radiobool: radiobool,
        arguments: arguments,
        radioprices: radioprices,
        radiopricesnum: radiopricesnum,
        NumCallBack: NumCallBack,
        requiredList: requiredList,
        requiredTitle: requiredTitle,
        multipleBool: multipleBool,
        requiredCheckBool: requiredCheckBool,
        requiredCheckPrices: requiredCheckPrices,
        max: max,
        min: min,
      );
}

class _RequiredRadioState extends State<RequiredRadio> {
  _RequiredRadioState({
    required this.lindex,
    required this.radioTitleList,
    required this.radioMultiple,
    required this.radiolist,
    required this.BoolCallBack,
    required this.radiobool,
    required this.arguments,
    required this.radioprices,
    required this.radiopricesnum,
    required this.NumCallBack,
    required this.requiredList,
    required this.requiredTitle,
    required this.multipleBool,
    required this.requiredCheckBool,
    required this.requiredCheckPrices,
    required this.max,
    required this.min,
  });
  final ValueChanged<bool> BoolCallBack;
  final ValueChanged<int> NumCallBack;
  Map arguments;
  List<String?> radioTitleList = [];
  List<bool?> radioMultiple = [];
  List<List> radiolist = [];
  int lindex;
  bool radiobool;
  List<int> radioprices;
  int radiopricesnum;
  List requiredList;
  String requiredTitle;
  bool multipleBool;
  List<List> requiredCheckBool;
  num requiredCheckPrices;
  String? max;
  String? min;

  ////
  late String selectValue = radiolist[lindex].toString();
  //
  final selectedColor = kMaimColor;
  final unselectedColor = Colors.white;
  late String option;

  @override
  void initState() {
    ////把每個傳進來的title加進list裡面
    radioTitleList.add(requiredTitle);
    ////把每個傳進來的multipul加進list裡面
    radioMultiple.add(multipleBool);
    ////如果radioList傳進來有值，代表是從購物車來的，selectValue就等於他的名字，預選就會打勾
    if (radiolist[lindex].isNotEmpty) {
      selectValue = radiolist[lindex][0];
    }
    ////
    ////
    if (multipleBool == false) {
      option = '單選';
    } else if (multipleBool = true) {
      option = '複選';
    }

    ///
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            MiddleText(
              color: kBodyTextColor,
              text: '${requiredTitle}',
              weight: FontWeight.bold,
            ),
            Expanded(
              child: Column(children: const []),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                    color: Colors.red.withOpacity(0.7),
                  ),
                  child: TabText(
                    color: kBodyTextColor,
                    text: '#必填',
                    fontFamily: 'NotoSansMedium',
                  ),
                ),
                if (multipleBool == false)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      color: Colors.blue.withOpacity(0.6),
                    ),
                    child: TabText(
                      color: kBodyTextColor,
                      text: '#單選',
                      fontFamily: 'NotoSansMedium',
                    ),
                  ),
                if (multipleBool == true)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      color: Colors.blue.withOpacity(0.6),
                    ),
                    child: Row(
                      children: [
                        TabText(
                          color: kBodyTextColor,
                          text: '#多選 ',
                          fontFamily: 'NotoSansMedium',
                        ),
                        if (min != null || max != null)
                          TabText(
                            color: kBodyTextColor,
                            text: ': ',
                            fontFamily: 'NotoSansMedium',
                          ),
                        if (min != null && max != null)
                          Row(
                            children: [
                              TabText(
                                color: kBodyTextColor,
                                text: '$min ~ ',
                                fontFamily: 'NotoSansMedium',
                              ),
                              TabText(
                                color: kBodyTextColor,
                                text: '$max',
                                fontFamily: 'NotoSansMedium',
                              ),
                            ],
                          ),
                        
                        if (min != null && max == null)
                          TabText(
                            color: kBodyTextColor,
                            text: '最少選擇 $min 項',
                            fontFamily: 'NotoSansMedium',
                          ),
                        if (min == null && max != null)
                          TabText(
                            color: kBodyTextColor,
                            text: '最多選擇 $max 項',
                            fontFamily: 'NotoSansMedium',
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        //單選
        if (multipleBool == false) buildRadios(),
        //多選
        if (multipleBool == true) buildCheck(),
      ],
    );
  }

  Widget buildCheck() => Column(
        children: List.generate(requiredList.length, (index) {
          ////初始化時requiredCheckBool裡的list是沒東西的，就給他都加上false
          if (requiredCheckBool[lindex].length < requiredList.length) {
            for (var i = 0; i < requiredList.length; i++)
              requiredCheckBool[lindex].add(false);
          }
          return buildSingleCheckbox(index);
        }),
      );
  Widget buildSingleCheckbox(index) => buildCheckbox(
      index: index,
      onlCicked: () {
        setState(() {
          var newValue = !requiredCheckBool[lindex][index];
          requiredCheckBool[lindex][index] = newValue;
          //選擇
          if (requiredCheckBool[lindex][index] == true) {
            radiolist[lindex].add(requiredList[index]['name']);
            requiredCheckPrices = radioprices[lindex];
            requiredCheckPrices += int.parse(requiredList[index]['cost']);
            radioprices[lindex] = requiredCheckPrices.toInt();
            requiredCheckBool[lindex]
                .insert(index, requiredCheckBool[lindex][index]);
            requiredCheckBool[lindex].removeAt(index);
            print('this is radiolist${radiolist}');
            print('this is requiredCheckBool${requiredCheckBool}');
            checkRadioBool();
            //取消選擇
          } else {
            radiolist[lindex].remove(requiredList[index]['name']);
            requiredCheckPrices = radioprices[lindex];
            requiredCheckPrices -= int.parse(requiredList[index]['cost']);
            radioprices[lindex] = requiredCheckPrices.toInt();
            requiredCheckBool[lindex]
                .insert(index, requiredCheckBool[lindex][index]);
            requiredCheckBool[lindex].removeAt(index);
            print('this is radiolist${radiolist}');
            print('this is requiredCheckBool${requiredCheckBool}');
            checkRadioBool();
          }

          // debugPrint(requiredCheckName.toString());
        });
      });

  Widget buildCheckbox({
    required int index,
    required VoidCallback onlCicked,
  }) {
    return ListTile(
      onTap: onlCicked,
      leading: Checkbox(
        value: requiredCheckBool[lindex][index],
        onChanged: (value) => onlCicked(),
        activeColor: kMaimColor,
      ),
      title: Row(
        children: [
          BetweenSM(
            color: kBodyTextColor,
            text: requiredList[index]['name'],
          ),
          Expanded(
            child: Column(children: const []),
          ),
          TabText(
            color: kBodyTextColor,
            text: ' \$ ${requiredList[index]['cost']}',
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget buildRadios() => Column(
        children: List.generate(
          requiredList.length,
          (index) {
            final selected =
                selectValue == requiredList[index]['name'].toString();
            selected ? selectedColor : unselectedColor;

            return RadioListTile<String>(
              value: requiredList[index]['name'].toString(),
              groupValue: selectValue,
              title: Row(
                children: [
                  BetweenSM(
                      color: kBodyTextColor,
                      text: requiredList[index]['name'].toString()),
                  Expanded(
                    child: Column(children: const []),
                  ),
                  Row(
                    children: [
                      TabText(
                        color: kBodyTextColor,
                        text: ' \$ ${requiredList[index]['cost']}',
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              activeColor: selectedColor,
              onChanged: (value) {
                setState(
                  () {
                    selectValue = value!;
                    ////
                    if (selectValue == value) {
                      radiolist[lindex].clear();
                      radiolist[lindex].add(selectValue);
                      radioprices.removeAt(lindex);
                      radioprices.insert(
                          lindex, int.parse(requiredList[index]['cost']));
                      print('this is radioprices${radioprices}');
                      print('this is radiolist${radiolist}');
                    }
                    ////必選都有選的話=true
                    checkRadioBool();

                    // debugPrint('${radiobool}');

                    // debugPrint(radiolist.toString());
                    ////
                  },
                );
              },
            );
          },
        ),
      );
  ////必選都選後radio = true，and計算單選多選多少錢
  void checkRadioBool() {
    var maxint;
    var minint;

    if (max == null) {
      maxint = requiredList.length;
    } else {
      maxint = int.parse(max!);
    }
    if (min == null) {
      minint = 1;
    } else {
      minint = int.parse(min!);
    }

    if (radiolist.every(
      (element) =>
          element.isNotEmpty &&
          radiolist[lindex].length <= maxint &&
          radiolist[lindex].length >= minint,
    )) {
      print('object2');
      radiopricesnum = 0;
      radiobool = true;
      BoolCallBack(radiobool);
      for (var element in radioprices) {
        radiopricesnum += element.toInt();
      }
      NumCallBack(radiopricesnum);
    } else {
      radiobool = false;
      BoolCallBack(radiobool);
    }
    print('this is radiopricesnum = ${radiopricesnum}');
    print('this is radioBool = ${radiobool}');
  }
}
