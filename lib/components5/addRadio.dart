import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';

class addRadio extends StatefulWidget {
  addRadio({
    Key? key,
    required this.addCheckBool,
    required this.addCheckPrices,
    required this.PricesCallBack,
    required this.addList,
    required this.addTitle,
    required this.multipleBool,
    required this.RadioTitleList,
    required this.RadioMultiple,
    required this.Radiolist,
    required this.Radioprices,
    required this.lindex,
    required this.Radiopricesnum,
    required this.max,
    required this.min,
    required this.BoolCallBack,
  }) : super(key: key);
  final ValueChanged<int> PricesCallBack;
  final ValueChanged<bool> BoolCallBack;
  List<List> addCheckBool;
  num addCheckPrices;
  List addList;
  String addTitle;
  bool multipleBool;
  List<String?> RadioTitleList;
  List<bool?> RadioMultiple;
  List<List> Radiolist;
  List<int> Radioprices;
  int lindex;
  int Radiopricesnum;
  String? max;
  String? min;
  @override
  State<addRadio> createState() => _addRadioState(
        addCheckBool: addCheckBool,
        addCheckPrices: addCheckPrices,
        PricesCallBack: PricesCallBack,
        addList: addList,
        addTitle: addTitle,
        multipleBool: multipleBool,
        RadioTitleList: RadioTitleList,
        RadioMultiple: RadioMultiple,
        Radiolist: Radiolist,
        Radioprices: Radioprices,
        lindex: lindex,
        Radiopricesnum: Radiopricesnum,
        max: max,
        min: min,
        BoolCallBack: BoolCallBack,
      );
}

class _addRadioState extends State<addRadio> {
  _addRadioState({
    required this.addCheckBool,
    required this.addCheckPrices,
    required this.PricesCallBack,
    required this.addList,
    required this.addTitle,
    required this.multipleBool,
    required this.RadioTitleList,
    required this.RadioMultiple,
    required this.Radiolist,
    required this.Radioprices,
    required this.lindex,
    required this.Radiopricesnum,
    required this.max,
    required this.min,
    required this.BoolCallBack,
  });
  List addList;
  List<List> addCheckBool;
  final ValueChanged<int> PricesCallBack;
  final ValueChanged<bool> BoolCallBack;
  num addCheckPrices;
  String addTitle;
  bool multipleBool;
  List<String?> RadioTitleList;
  List<bool?> RadioMultiple;
  List<List> Radiolist;
  List<int> Radioprices;
  int lindex;
  int Radiopricesnum;
  String? max;
  String? min;
  ////
  late String selectValue = Radiolist[lindex].toString();
  //
  final selectedColor = kMaimColor;
  final unselectedColor = Colors.white;
  late String option;
  @override
  void initState() {
    ////把每個傳進來的title加進list裡面
    RadioTitleList.add(addTitle);
    ////把每個傳進來的title加進list裡面
    RadioMultiple.add(multipleBool);
    ////如果radioList傳進來有值，代表是從購物車來的，selectValue就等於他的名字，預選就會打勾
    if (Radiolist[lindex].isNotEmpty) {
      selectValue = Radiolist[lindex][0];
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            MiddleText(
              color: kBodyTextColor,
              text: '$addTitle',
              weight: FontWeight.bold,
            ),
            Expanded(
              child: Column(children: const []),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                color: Colors.grey.withOpacity(0.6),
              ),
              child: TabText(
                color: kBodyTextColor,
                text: '可選',
                fontFamily: 'NotoSansMedium',
              ),
            ),
            if (multipleBool == true)
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
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
        SizedBox(height: Dimensions.height10),
        if (multipleBool == false) buildRadios(),
        if (multipleBool == true) buildCheck(),
      ],
    );
  }

  Widget buildCheck() => Column(
        children: List.generate(
          addList.length,
          (index) {
            if (addCheckBool[lindex].length < addList.length) {
              for (var i = 0; i < addList.length; i++)
                addCheckBool[lindex].add(false);
            }
            return buildSingleCheckbox(index);
          },
        ),
      );

  Widget buildSingleCheckbox(index) => buildCheckbox(
      index: index,
      onlCicked: () {
        setState(() {
          final newValue = !addCheckBool[lindex][index];
          addCheckBool[lindex][index] = newValue;
          if (addCheckBool[lindex][index] == true) {
            Radiolist[lindex].add(addList[index]['name']);
            addCheckPrices = Radioprices[lindex];
            addCheckPrices += int.parse(addList[index]['cost']);
            Radioprices[lindex] = addCheckPrices.toInt();
            addCheckBool[lindex].insert(index, addCheckBool[lindex][index]);
            addCheckBool[lindex].removeAt(index);
            print('this is Radiolist${Radiolist}');
            print('this is addCheckBool${addCheckBool}');
          } else {
            Radiolist[lindex].remove(addList[index]['name']);
            addCheckPrices = Radioprices[lindex];
            addCheckPrices -= int.parse(addList[index]['cost']);
            Radioprices[lindex] = addCheckPrices.toInt();
            addCheckBool[lindex].insert(index, addCheckBool[lindex][index]);
            addCheckBool[lindex].removeAt(index);
            print('this is Radiolist${Radiolist}');
            print('this is addCheckBool${addCheckBool}');
          }
          checkTotal();
          // debugPrint(addCheckName.toString());
        });
      });

  Widget buildCheckbox({
    required int index,
    required VoidCallback onlCicked,
  }) {
    return ListTile(
      onTap: onlCicked,
      leading: Checkbox(
        value: addCheckBool[lindex][index],
        onChanged: (value) => onlCicked(),
        activeColor: kMaimColor,
      ),
      title: Row(
        children: [
          BetweenSM(
            color: kBodyTextColor,
            text: addList[index]['name'],
          ),
          Expanded(
            child: Column(children: const []),
          ),
          TabText(
            color: kBodyTextColor,
            text: ' \$ ${addList[index]['cost']}',
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget buildRadios() => Column(
        children: List.generate(
          addList.length,
          (index) {
            final selected = selectValue == addList[index]['name'].toString();
            selected ? selectedColor : unselectedColor;

            return RadioListTile<String>(
              value: addList[index]['name'].toString(),
              groupValue: selectValue,
              title: Row(
                children: [
                  BetweenSM(
                      color: kBodyTextColor,
                      text: addList[index]['name'].toString()),
                  Expanded(
                    child: Column(children: const []),
                  ),
                  Row(
                    children: [
                      TabText(
                        color: kBodyTextColor,
                        text: ' \$ ${addList[index]['cost']}',
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
                      Radiolist[lindex].clear();
                      Radiolist[lindex].add(selectValue);
                      Radioprices.removeAt(lindex);
                      Radioprices.insert(
                          lindex, int.parse(addList[index]['cost']));
                      print('this is Radioprices${Radioprices}');
                      print('this is Radiolist${Radiolist}');
                    }
                    checkTotal();
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
  void checkTotal() {
    var maxint;
    var minint;
    var bool;

    if (max == null) {
      maxint = addList.length;
    } else {
      maxint = int.parse(max!);
    }
    if (min == null) {
      minint = 0;
    } else {
      minint = int.parse(min!);
    }
    if (Radiolist[lindex].length <= maxint &&
        Radiolist[lindex].length >= minint) {
      bool = true;
      Radiopricesnum = 0;

      for (var element in Radioprices) {
        Radiopricesnum += element.toInt();
      }
      PricesCallBack(Radiopricesnum);
      BoolCallBack(bool);

      print('this is Radiopricesnum = ${Radiopricesnum}');
    }else{
      bool = false;
      BoolCallBack(bool);
    }
  }
}

class NotificationSetting {
  String name;
  int price;
  bool value;

  NotificationSetting(
      {required this.name, this.value = false, required this.price});
}
