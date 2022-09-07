import 'package:flutter/material.dart';
import 'package:flutterdemo02/components5/textField.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/BigText.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:get/get.dart';

import '../components5/requiredRadio.dart';
import '../components5/addRadio.dart';

class FormPage5 extends StatefulWidget {
  Map arguments;
  FormPage5({Key? key, required this.arguments}) : super(key: key);

  @override
  State<FormPage5> createState() => _FormPage5State(arguments: arguments);
}

class _FormPage5State extends State<FormPage5> {
  var radiobool = false;
  final cartController = Get.put(CartController());
  var textController = TextEditingController(text: '無備註');
  @override
  _FormPage5State({required this.arguments});
  ////必選多選單選總商品清單
  List<List> radiolist = []; //[[選擇1, 選擇3, 選擇2], [選擇5], [選擇7, 選擇8], [選擇10]]
  List<String?> radioTitleList = []; //[title,title,title,title]
  List<bool?> radioMultiple = []; //[false,true,true,true]
  List<int> radioprices = []; //[0, 4, 0, 0]
  int radiopricesnum = 0; //radioprices的總額
  ////必選多選
  num requiredCheckPrices = 0; //radioprices紀錄每個index目前值
  List<List> requiredCheckBool =
      []; //必選哪幾項被選中[[true,false,false,true,[],[true,false,false,true],[]]
  ////必選多選單選總商品清單
  List<List> Radiolist = []; //[[選擇1, 選擇3, 選擇2], [選擇5], [選擇7, 選擇8], [選擇10]]
  List<String?> RadioTitleList = []; //[title,title,title,title]
  List<bool?> RadioMultiple = []; //[false,true,true,true]
  List<int> Radioprices = []; //[0, 4, 0, 0]
  int Radiopricesnum = 0; //radioprices的總額
  ////非必選多選
  num addCheckPrices = 0; //加選商品價
  List<List> addCheckBool = []; //加選哪幾項被選中
  ////
  Map arguments;

  @override
  void initState() {
    print(arguments['options']);
    ////如果沒有必選那購物車打開
    if (requiredList().isEmpty) {
      radiobool = true;
    }
    print('add list ${addList()}');
    ////從購物車來，就換這些資料因為總價會寫在ToCart上
    setState(() {
      if (arguments['radiopricesnum'] != null) {
        radiopricesnum = arguments['radiopricesnum'];
        radiobool = true;
        textController = TextEditingController(text: arguments['text']);
        print('yes');
      }
      if (arguments['Radiopricesnum'] != null) {
        Radiopricesnum = arguments['Radiopricesnum'];
        textController = TextEditingController(text: arguments['text']);
        print('yes');
      }
      // if (arguments['addCheckPrices'] != null) {
      //   addCheckPrices += arguments['addCheckPrices'];
      // }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ////必選列表////
  List<dynamic> requiredList() {
    List<dynamic> data3 = [];
    List data2 = [];
    List data = arguments['options'];

    data2 = data.where((element) => element['requires'] == true).toList();

    return data2;
  }

  ////////////////
  /////加選列表////
  List addList() {
    List data3 = [];
    List data2 = [];
    List data = arguments['options'];

    data2 = data.where((element) => element['requires'] == false).toList();
    return data2;
  }

  ////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe8e8e8),
              blurRadius: 5.0,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.do_not_disturb_on_outlined,
                      size: Dimensions.icon32,
                      color: kMaimColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (arguments['firstNumber'] > 1) {
                          arguments['firstNumber']--;
                        } else {
                          arguments['firstNumber'] = 1;
                          print('最小了啦');
                        }
                      });
                    },
                  ),
                  MiddleText(
                    color: kBodyTextColor,
                    text: '${arguments['firstNumber']}',
                    weight: FontWeight.bold,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: Dimensions.icon32,
                      color: kMaimColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (arguments['firstNumber'] > 0) {
                          arguments['firstNumber']++;
                        } else {
                          arguments['firstNumber'] = 1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.height10),
                child: Card(
                  color: radiobool ? kMaimColor : kTextLightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Dimensions.height10),
                        child: TextButton(
                          onPressed: () {
                            // debugPrint(_checkIndex.toString());
                            // debugPrint(_addCheckName.toString());
                            // final List choses =[chosename,chosenumber,choseprice];
                            // Navigator.pop(context,choses);

                            if (radiobool == true ||
                                arguments['radiovalue'] != null) {
                              Navigator.pop(context, false);
                              String? text;
                              if (textController.text.isEmpty) {
                                text = null;
                              } else {
                                text = textController.text;
                              }
                              if (arguments['id'] == false) {
                                cartController
                                    .delete(cartController.updateDeleteIndex);
                              }

                              radiopricesnum = 0;
                              for (var element in radioprices) {
                                radiopricesnum += element.toInt();
                              }
                              Radiopricesnum = 0;
                              for (var element in Radioprices) {
                                Radiopricesnum += element.toInt();
                              }

                              cartController.addProduct(
                                radiolist: radiolist,
                                radioTitleList: radioTitleList,
                                radioMultiple: radioMultiple,
                                id: arguments['Id'],
                                name: arguments['name'],
                                price: arguments['price'],
                                quantity: arguments['firstNumber'],
                                textprice: arguments['textprice'],
                                text: text,
                                shopname: arguments['shopname'],
                                image: arguments['image'],
                                description: arguments['description'],
                                addCheckBool: addCheckBool,
                                radioprices: radioprices,
                                radiopricesnum: radiopricesnum,
                                options: arguments['options'],
                                requiredCheckBool: requiredCheckBool,
                                RadioTitleList: RadioTitleList,
                                RadioMultiple: RadioMultiple,
                                Radiolist: Radiolist,
                                Radioprices: Radioprices,
                                Radiopricesnum: Radiopricesnum,
                              );
                              cartController.ifUpdate(name: true);
                            } else {
                              showDeleteDialod();
                            }
                          },
                          child: Row(
                            children: [
                              MiddleText(
                                color: radiobool ? Colors.white : kBottomColor,
                                text: arguments['ToCart'],
                                weight: FontWeight.w700,
                              ),
                              if (radiobool == true)
                                MiddleText(
                                  color: Colors.white,
                                  text:
                                      '${(arguments['price'] + Radiopricesnum + radiopricesnum) * arguments['firstNumber']}',
                                  weight: FontWeight.w700,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: kMaim3Color,
          child: SafeArea(
            child: Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: Dimensions.screenHeigt / 4.12,
                    //往上滑一點APPBAR就會跑出來
                    // floating: true,
                    //只有Expanded的部分會隱藏
                    pinned: true,
                    stretch: true,
                    flexibleSpace: LayoutBuilder(
                      builder: ((context, constraints) {
                        var top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          background: Column(
                            children: [
                              if (arguments['image'] != null)
                                Image.asset(
                                  arguments['image'],
                                  fit: BoxFit.cover,
                                ),
                            ],
                          ),
                          title: AnimatedOpacity(
                            opacity: top <= Dimensions.screenHeigt / 14.47
                                ? 1.0
                                : 0.0,
                            duration: const Duration(milliseconds: 100),
                            child: Row(
                              children: [
                                MiddleText(
                                  color: kBodyTextColor,
                                  text: arguments['name'],
                                  fontFamily: 'NotoSansMedium',
                                ),
                                SizedBox(width: Dimensions.width20 * 4),
                                BetweenSM(
                                    color: kBodyTextColor,
                                    text: '\$ ${arguments['textprice']} 起',
                                    fontFamily: 'NotoSansMedium'),
                              ],
                            ),
                          ),

                          //在上升的時候背景圖片固定
                          collapseMode: CollapseMode.pin,
                          stretchModes: const <StretchMode>[
                            StretchMode.blurBackground
                          ],
                        );
                      }),
                    ),
                    automaticallyImplyLeading: true,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        width: Dimensions.height20 * 1.6,
                        height: Dimensions.height20 * 1.6,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20 * 2),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.chevron_left_outlined,
                          color: kMaimColor,
                          size: Dimensions.icon25 * 1.2,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          left: Dimensions.width10,
                          right: Dimensions.width10,
                          top: Dimensions.height15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: BigText(
                                  color: kBodyTextColor,
                                  text: arguments['name'],
                                  weight: FontWeight.bold,
                                  maxLines: 1,
                                ),
                              ),
                              Expanded(
                                child: Column(children: const []),
                              ),
                              Row(
                                children: [
                                  TabText(
                                    color: kBodyTextColor,
                                    text: '\$ ${arguments['price']} 起',
                                    weight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.height5),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: kTextLightColor),
                              BetweenSM(
                                  color: kTextLightColor,
                                  text: arguments['shopname'])
                            ],
                          ),
                          SizedBox(height: Dimensions.height10),
                          if (arguments['description'] != null)
                            Row(
                              children: [
                                Expanded(
                                  child: TabText(
                                    maxLines: 5,
                                    color: kTextLightColor,
                                    text: arguments['description'],
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: Dimensions.height10),
                        ],
                      ),
                    ),
                  ),
                  if (requiredList().isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          child: Column(
                            children:
                                List.generate(requiredList().length, (index) {
                              ////如果從購物車傳來，給初始
                              if (arguments['radiolist'] != null) {
                                radiolist = arguments['radiolist'];
                              }

                              if (arguments['radioprices'] != null) {
                                radioprices = arguments['radioprices'];
                              }
                              if (arguments['requiredCheckBool'] != null) {
                                requiredCheckBool =
                                    arguments['requiredCheckBool'];
                              }

                              ///
                              ////如果radiolist的長度不到radiodata的長度(就是還沒給足初始直'')，就繼續跑
                              if (radiolist.length != requiredList().length) {
                                plusRadio(list: []);
                              }
                              if (requiredCheckBool.length !=
                                  requiredList().length) {
                                plusCheck(list: []);
                              }
                              if (radioprices.length != requiredList().length) {
                                plusRadioPrices(name: 0);
                              }
                              // debugPrint(radiolist.toString());

                              return RequiredRadio(
                                BoolCallBack: (value) {
                                  setState(() {
                                    radiobool = value;
                                  });
                                },
                                NumCallBack: (value) {
                                  setState(() {
                                    radiopricesnum = value;
                                  });
                                },
                                arguments: arguments,
                                radiobool: radiobool,
                                radioTitleList: radioTitleList,
                                radioMultiple: radioMultiple,
                                radiolist: radiolist,
                                radioprices: radioprices,
                                lindex: index,
                                radiopricesnum: radiopricesnum,
                                requiredList: requiredList()[index]['option'],
                                requiredTitle: requiredList()[index]['title'],
                                multipleBool: requiredList()[index]['multiple'],
                                max: requiredList()[index]['max'],
                                min: requiredList()[index]['min'],
                                requiredCheckPrices: requiredCheckPrices,
                                requiredCheckBool: requiredCheckBool,
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  if (addList().isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          child: Column(
                            children: List.generate(addList().length, (index) {
                              //如果從購物車傳來，給初始
                              if (arguments['Radiolist'] != null) {
                                Radiolist = arguments['Radiolist'];
                              }

                              if (arguments['addCheckBool'] != null) {
                                addCheckBool = arguments['addCheckBool'];
                              }
                              if (arguments['Radioprices'] != null) {
                                Radioprices = arguments['Radioprices'];
                              }

                              ///
                              ////如果radiolist的長度不到radiodata的長度(就是還沒給足初始直'')，就繼續跑
                              if (Radiolist.length != addList().length) {
                                PlusRadio(list: []);
                              }
                              if (addCheckBool.length != addList().length) {
                                PlusCheck(list: []);
                              }
                              if (Radioprices.length != addList().length) {
                                PlusRadioPrices(name: 0);
                              }

                              return addRadio(
                                BoolCallBack: (value) {
                                  setState(() {
                                    radiobool = value;
                                  });
                                },
                                  PricesCallBack: (value) {
                                    setState(() {
                                      Radiopricesnum = value;
                                    });
                                  },
                                  arguments: arguments,
                                  addCheckBool: addCheckBool,
                                  addCheckPrices: addCheckPrices,
                                  addList: addList()[index]['option'],
                                  addTitle: addList()[index]['title'],
                                  multipleBool: addList()[index]['multiple'],
                                  max: addList()[index]['max'],
                                  min: addList()[index]['min'],
                                  RadioTitleList: RadioTitleList,
                                  RadioMultiple: RadioMultiple,
                                  Radiolist: Radiolist,
                                  Radioprices: Radioprices,
                                  lindex: index,
                                  Radiopricesnum: Radiopricesnum);
                            }),
                          ),
                        ),
                      ),
                    ),
                  textField(
                    textController: textController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ////必選
  void plusRadio({
    required List list,
  }) {
    radiolist.add(list);
  }

  void plusCheck({
    required List list,
  }) {
    requiredCheckBool.add(list);
  }

  void plusRadioPrices({
    required int name,
  }) {
    radioprices.add(name);
  }

  ////
  ////非必選
  void PlusRadio({
    required List list,
  }) {
    Radiolist.add(list);
  }

  void PlusCheck({
    required List list,
  }) {
    addCheckBool.add(list);
  }

  void PlusRadioPrices({
    required int name,
  }) {
    Radioprices.add(name);
  }
  ////
  // void turnfalse() {
  //   checkboxData.forEach((element) {
  //     element.update(('value'), (value) => value = false);
  //   });
  // }

  Future<bool?> showDeleteDialod() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text('請看選擇提示，正確填選後方能加入購物車'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('確認'),
            ),
          ],
        );
      },
    );
  }
}
