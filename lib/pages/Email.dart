import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../models/BetweenSM.dart';
import '../models/ColorSettings.dart';
import '../models/TabsText.dart';

class Email extends StatefulWidget {
  Email({Key? key}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  var title = TextEditingController(text: '');
  bool titleError = false;
  var body = TextEditingController(text: '');
  bool bodyError = false;

  Future sendEmail() async {
    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': 'service_4cxurh4',
        'template_id': 'template_uyhh4rn',
        'user_id': 'oC_J8W8m15fe8CJa6',
        'template_params': {
          'user_name': UserSimplePreferences.getUserName(),
          'user_email': UserSimplePreferences.getUserEmail(),
          'user_subject': title.text,
          'user_message': body.text,
        }
      }),
    );
    print('${title.text}');
    print('${body.text}');
    print('${UserSimplePreferences.getUserName()}');
    print('${UserSimplePreferences.getUserEmail()}');
    print(' response.statusCode in email.dart is ${response.statusCode} ');
    print(' response.body in email.dart is ${response.body} ');
  }

  @override
  void initState() {
    body.addListener(() {
      body.text != '' ? bodyError = false : true;
      setState(() {});
    });
    title.addListener(() {
      title.text != '' ? titleError = false : true;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    body.removeListener(() {
      body.text != '' ? bodyError = false : true;
    });
    title.removeListener(() {
      title.text != '' ? titleError = false : true;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: BetweenSM(
          color: kBodyTextColor,
          text: '問題回報',
          fontFamily: 'NotoSansMedium',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: kMaimColor,
            size: Dimensions.icon25,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: kMaimColor,
              size: Dimensions.icon25,
            ),
            onPressed: () async {
              if (title.text == '') {
                setState(() {
                  titleError = true;
                });
              } else if (body.text == '') {
                setState(() {
                  bodyError = true;
                });
              } else {
                Navigator.pop(context);
                await sendEmail();
                Get.snackbar(
                "發送成功",
                "我們將以郵件的方式回覆您~",
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(
                  seconds: 2,
                ),
              );
              }

              
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.height15),
              child: Column(
                children: [
                  Container(
                    height: Dimensions.height50,
                  ),
                  Container(
                    width: Dimensions.screenWidth,
                    height: Dimensions.height50 * 11,
                    child: Card(
                      color: Colors.white,
                      elevation: Dimensions.height5,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.height15),
                        child: Column(
                          children: [
                            Container(
                              height: Dimensions.height20,
                            ),
                            TextField(
                              controller: title,
                              maxLength: 20,
                              maxLines: 1,
                              decoration: InputDecoration(
                                label:
                                    TabText(color: kTextLightColor, text: '主旨'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius10),
                                  borderSide: BorderSide(
                                    color: kBottomColor!,
                                  ),
                                ),
                                errorText: titleError ? '不可為空' : null,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius10),
                                  borderSide: BorderSide(
                                    color: kBottomColor!,
                                  ),
                                ),
                              ),
                              //使用者輸入帳號有內鍵
                              keyboardType: TextInputType.emailAddress,
                              //使用者鍵盤多一個"done"鍵盤
                              textInputAction: TextInputAction.done,
                            ),
                            Container(
                              height: Dimensions.height20,
                            ),
                            TextField(
                              controller: body,
                              maxLength: 500,
                              maxLines: 10,
                              decoration: InputDecoration(
                                label: TabText(
                                    color: kTextLightColor, text: '撰寫電子郵件'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius10),
                                  borderSide: BorderSide(
                                    color: kBottomColor!,
                                  ),
                                ),
                                errorText: bodyError ? '不可為空' : null,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius10),
                                  borderSide: BorderSide(
                                    color: kBottomColor!,
                                  ),
                                ),
                              ),
                              //使用者輸入帳號有內鍵
                              keyboardType: TextInputType.emailAddress,
                              //使用者鍵盤多一個"done"鍵盤
                              textInputAction: TextInputAction.done,
                            ),
                            Padding(
                              padding: EdgeInsets.all(Dimensions.height15 * 2),
                              child: MiddleText(
                                color: kTextLightColor,
                                text: '我們將以郵件方式回覆您~',
                                fontFamily: 'NotoSansMedium',
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // void showSnackBar(String text) {
  //     final snackBar = SnackBar(
  //       content: Text(
  //         text,
  //         style: TextStyle(fontSize: 20),
  //       ),
  //       backgroundColor: Colors.green,
  //     );

  //     ScaffoldMessenger.of(context)
  //       ..removeCurrentSnackBar()
  //       ..showSnackBar(snackBar);
  //   }
}
