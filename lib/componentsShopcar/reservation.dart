import 'package:flutter/material.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/pages/Tabs.dart';
import 'package:get/get.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import '../models/BetweenSM.dart';
import '../models/ColorSettings.dart';
import '../models/MiddleText.dart';
import '../models/TabsText.dart';
import '../provider/Shared_Preference.dart';

class Reservation extends StatefulWidget {
  Reservation({
    Key? key,
    required this.notifyParent,
    required this.businessTime,
    required this.selectTime,
    required this.BoolCallBack,
  }) : super(key: key);
  Function() notifyParent;
  List businessTime;
  bool selectTime = false;
  final ValueChanged<bool> BoolCallBack;
  @override
  State<Reservation> createState() => _ReservationState(
        notifyParent: notifyParent,
        businessTime: businessTime,
        selectTime: selectTime,
        BoolCallBack: BoolCallBack,
      );
}

class _ReservationState extends State<Reservation> {
  _ReservationState({
    required this.notifyParent,
    required this.businessTime,
    required this.selectTime,
    required this.BoolCallBack,
  });
  List businessTime;
  CartController cartController = Get.find();
  Function() notifyParent;
  int nowHour = 0;
  int nowMin = 0;
  bool selectTime = false;
  bool reservationClose = false;
  List availableHours = [];
  List availableMin = [];
  final ValueChanged<bool> BoolCallBack;
  TimeOfDay nowTime = TimeOfDay(
    hour: TimeOfDay.now().hour,
    minute: TimeOfDay.now().minute,
  );

  List? choseFuture;
  bool? choseNow = false;

  List<List> startMin = [];
  List<List> endMin = [];
  setTime(lindex) {
    nowTime = TimeOfDay(
      hour: TimeOfDay.now().hour,
      minute: TimeOfDay.now().minute,
    );
    if (availableHours[lindex] == nowTime.hour.toInt() + 1) {
      int x = nowTime.minute ~/ 10; //取整數
      if (x == 0) {
      } else {
        startMin = [
          ['00', '10', '20', '30', '40', '50']
        ];
        endMin = [
          ['10', '20', '30', '40', '50', '00']
        ];
        startMin.first.removeRange(0, x + 1);
        endMin.first.removeRange(0, x + 1);
      }
    } else {
      startMin.add(['00', '10', '20', '30', '40', '50']);
      endMin.add(['00', '10', '20', '30', '40', '50']);
    }
    print('startMin is $startMin');
    print('endMin is $endMin');
  }

  setHour() {
    nowTime = TimeOfDay(
      hour: TimeOfDay.now().hour,
      minute: TimeOfDay.now().minute,
    );
    nowMin = nowTime.minute;
    for (nowMin = nowTime.minute; nowMin % 5 != 0; nowMin++) {}
    nowTime = TimeOfDay(
      hour: TimeOfDay.now().hour,
      minute: nowMin,
    );
    availableHours = [];
    for (var i = 0; i < businessTime.length; i++) {
      print('now time is $nowTime');
      if (businessTime[i] == true && i >= nowTime.hour.toInt() + 1) {
        availableHours.add(i);
      }
    }
    print('availableHours is $availableHours');
    if (availableHours.isEmpty) {
      reservationClose = true;
    }
  }

  @override
  void initState() {
    setHour();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height10,
              horizontal: Dimensions.width15,
            ),
            child: Text(
              '取餐方式',
              style: TextStyle(fontSize: Dimensions.fontsize24),
            ),
          ),
        ),
        ListTile(
          leading: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height10,
              horizontal: Dimensions.width15,
            ),
            child: Icon(
              Icons.schedule_outlined,
              size: Dimensions.icon25,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(
              left: Dimensions.width15,
              top: Dimensions.height15,
            ),
            child: Row(
              children: [
                MiddleText(
                  color: kBodyTextColor,
                  text: '時間',
                  fontFamily: 'NotoSansMedium',
                ),
                Expanded(
                  child: Column(
                    children: const [],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Container(
                height: Dimensions.height10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (choseNow == true) {
                      choseNow = false;
                      selectTime = false;
                    } else {
                      choseNow = true;
                      selectTime = true;
                      choseFuture = null;
                      cartController.getReservation(
                        Time: null,
                      );
                      cartController.ifUpdate(name: true);
                      BoolCallBack(selectTime);
                      widget.notifyParent();
                    }
                  },
                  child: Card(
                    elevation: Dimensions.height5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius10,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TabText(
                            color: kBodyTextColor,
                            text: '即時單',
                            fontFamily: 'NotoSansMedium',
                          ),
                          SizedBox(
                            width: Dimensions.width10,
                          ),
                          choseNow == false
                              ? Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.grey,
                                )
                              : Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.green,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await setHour();
                    if (availableHours.isEmpty) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            title: MiddleText(
                              color: kBodyTextColor,
                              text: '已過了最晚預約時間',
                              fontFamily: 'NotoSansMedium',
                            ),
                            content: Column(
                              children: [
                                TabText(
                                  color: kBodyTextColor,
                                  text: '今日已不提供預約，請改用即時單!',
                                  fontFamily: 'NotoSansMedium',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: TabText(
                                  color: Colors.blue,
                                  text: '知道了',
                                  fontFamily: 'NotoSansMedium',
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      choseFuture = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Row(
                              children: [
                                MiddleText(
                                  color: kBodyTextColor,
                                  text: '請選擇取餐時間',
                                  fontFamily: 'NotoSansMedium',
                                ),
                                Icon(
                                  Icons.south,
                                  size: Dimensions.icon25,
                                )
                              ],
                            ),
                            content: Column(
                              children: List.generate(
                                availableHours.length,
                                (lindex) {
                                  setTime(lindex);
                                  String canText = '';
                                  if (availableHours[lindex] == 0) {
                                    canText = '00';
                                  } else if (availableHours[lindex] != 0) {
                                    if (availableHours[lindex] > 12) {
                                      canText =
                                          '${availableHours[lindex] - 12}';
                                    } else {
                                      canText = '${availableHours[lindex]}';
                                    }
                                  }
                                  String canNoon = '';
                                  if (availableHours[lindex] < 12) {
                                    canNoon = '上午';
                                  } else {
                                    canNoon = '下午';
                                  }

                                  return Column(
                                    children: List.generate(
                                      startMin[lindex].length,
                                      (index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: Dimensions.height10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context, [
                                                  '$canNoon $canText : ${startMin[lindex][index]} - ${endMin[lindex][index] == '00' ? int.parse(canText) + 1 : int.parse(canText)} : ${endMin[lindex][index]}',
                                                  '${canNoon == '上午' ? canText : (int.parse(canText) + 12).toString()}:${startMin[lindex][index]}',
                                                ]);
                                              },
                                              child: Card(
                                                elevation: Dimensions.height5,
                                                shadowColor: Colors.black54,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Dimensions.radius10,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimensions.width20,
                                                    vertical:
                                                        Dimensions.height15,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TabText(
                                                        color: kBodyTextColor,
                                                        text:
                                                            '$canNoon $canText : ${startMin[lindex][index]} - ${endMin[lindex][index] == '00' ? int.parse(canText) + 1 : int.parse(canText)} : ${endMin[lindex][index]}',
                                                        fontFamily:
                                                            'NotoSansMedium',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }

                    //if 'OK' => TimeOfDay
                    print(
                        'choseTime is ${choseFuture![1].toString().padLeft(5, '0')}');
                    print('reservationClose is ${reservationClose}');
                    cartController.getReservation(
                      Time: '${choseFuture![1].toString().padLeft(5, '0')}',
                    );
                    if (choseFuture != null) {
                      choseNow = false;
                      selectTime = true;
                      BoolCallBack(selectTime);
                      cartController.ifUpdate(name: true);
                      widget.notifyParent();
                    }
                  },
                  child: Card(
                    elevation: Dimensions.height5,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radius10,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TabText(
                            color: kBodyTextColor,
                            text: '預約單',
                            fontFamily: 'NotoSansMedium',
                          ),
                          SizedBox(
                            width: Dimensions.width10,
                          ),
                          choseFuture == null
                              ? reservationClose
                                  ? Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    )
                                  : Icon(Icons.check_box_outline_blank)
                              : Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.green,
                                ),
                          choseFuture != null
                              ? SmallText(
                                  color: kBodyTextColor,
                                  text: '(${choseFuture!.first} )',
                                  fontFamily: 'NotoSansMedium',
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Divider()
            ],
          ),
        ),
      ],
    );
  }
}
