import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/TabsText.dart';

class textField extends StatefulWidget {
  final TextEditingController textController;

  const textField({Key? key, required this.textController}) : super(key: key);

  @override
  State<textField> createState() => _textFieldState();
}

class _textFieldState extends State<textField> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(
                left: Dimensions.width15, right: Dimensions.width15),
            child: Column(
              children: [
                const Divider(),
                SizedBox(height: Dimensions.height10),
                Row(
                  children: [
                    MiddleText(
                      color: kBodyTextColor,
                      text: '餐點備註',
                      weight: FontWeight.bold,
                    )
                  ],
                ),
                SizedBox(height: Dimensions.height10),
                TextField(
                  controller: widget.textController,
                  maxLength: 500,
                  maxLines: 4,
                  decoration: InputDecoration(
                    label: TabText(color: kTextLightColor, text: '例:不要香菜、加辣'),
                    // // prefixIcon: Icon(Icons.email),
                    // //如果裡面沒有輸入東西，suffix那裏就是空白容器，不然，就會有叉叉。。但每次輸入都要測試有沒有東西，所以每次輸入就要listener Setstate一次，在上面宣告
                    // suffixIcon: textController.text.isEmpty
                    //     ? Container(
                    //         width: 0,
                    //       )
                    //     : IconButton(
                    //         icon: Icon(Icons.close),
                    //         //按下叉叉清除輸入過的帳號
                    //         onPressed: () => textController.clear()),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      borderSide: BorderSide(
                        color: kBottomColor!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                      borderSide: const BorderSide(
                        color: kMaimColor,
                      ),
                    ),
                  ),
                  //使用者輸入帳號有內鍵
                  keyboardType: TextInputType.emailAddress,
                  //使用者鍵盤多一個"done"鍵盤
                  textInputAction: TextInputAction.done,
                ),
              ],
            )),
      ),
    );
  }
}
