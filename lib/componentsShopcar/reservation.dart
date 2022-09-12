import 'package:flutter/material.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutterdemo02/pages/Tabs.dart';
import 'package:get/get.dart';

import '../models/BetweenSM.dart';
import '../models/ColorSettings.dart';
import '../models/MiddleText.dart';
import '../models/TabsText.dart';
import '../provider/Shared_Preference.dart';

class Reservation extends StatefulWidget {
  Reservation({Key? key, required this.notifyParent}) : super(key: key);
  Function() notifyParent;
  @override
  State<Reservation> createState() =>
      _ReservationState(notifyParent: notifyParent);
}

class _ReservationState extends State<Reservation> {
  _ReservationState({required this.notifyParent});

  CartController cartController = Get.find();
  Function() notifyParent;
  TimeOfDay time = TimeOfDay(
    hour: TimeOfDay.now().hour,
    minute: TimeOfDay.now().minute,
  );

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
                    text: '${cartController.reservationTime}',
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
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );

                      //if 'Cancel' => null
                      if (newTime == null) return;

                      //if 'OK' => TimeOfDay

                      time = newTime;
                      cartController.getReservation(
                          Time:
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
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
