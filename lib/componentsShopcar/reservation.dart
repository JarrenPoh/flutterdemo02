import 'package:flutter/material.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
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
  bool? selectTime;
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
  bool? selectTime;
  List availableHours = [];
  List availableMin = [];
  final ValueChanged<bool> BoolCallBack;
  TimeOfDay nowTime = TimeOfDay(
    hour: TimeOfDay.now().hour,
    minute: TimeOfDay.now().minute,
  );
  @override
  void initState() {
    nowMin = nowTime.minute;
    for (nowMin = nowTime.minute; nowMin % 5 != 0; nowMin++) {}
    nowTime = TimeOfDay(
      hour: TimeOfDay.now().hour,
      minute: nowMin,
    );

    for (var i = 0; i < businessTime.length; i++) {
      if (businessTime[i] == true) {
        availableHours.add(i);
      }
    }
    print('availableHours is $availableHours');

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
              )),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: Dimensions.width20 * 2, height: 2),
                  BetweenSM(
                    color: kBodyTextColor,
                    text: selectTime != true
                        ? '點擊修改 ->'
                        : '${cartController.reservationTime}',
                    fontFamily: 'NotoSansMedium',
                    maxLines: 100,
                  ),
                  TextButton(
                    child: BetweenSM(
                      color: kMaimColor,
                      text: '修改',
                      fontFamily: 'NotoSansMedium',
                      maxLines: 100,
                    ),
                    onPressed: () async {
                      print('nowTime is $nowTime');
                      TimeOfDay? newTime = await showCustomTimePicker(
                        context: context,
                        onFailValidation: (context) => print('不可選定此時間'),
                        initialTime: nowTime,
                        selectableTimePredicate: (utime) =>
                            availableHours.indexOf(utime!.hour) != -1,
                      );

                      //if 'Cancel' => null
                      if (newTime == null) return;

                      //if 'OK' => TimeOfDay
                      print('newTime is $newTime');
                      cartController.getReservation(
                          Time:
                              '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}');
                      selectTime = true;
                      BoolCallBack(selectTime!);
                      cartController.ifUpdate(name: true);
                      widget.notifyParent();
                    },
                  ),
                ],
              ),
              const Divider()
            ],
          ),
        ),
      ],
    );
  }
}
