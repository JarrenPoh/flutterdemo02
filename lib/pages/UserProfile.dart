import 'package:flutter/material.dart';
import 'package:flutterdemo02/componentsUserProfile/UserCard.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:http/http.dart' as http;
import '../models/BetweenSM.dart';
import '../models/TabsText.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void close() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  deleteAccount(key) {
    var response = http.delete(
      Uri.parse('https://hello-cycu-delivery-service.herokuapp.com/member'),
      headers: {
        "token": key,
        "Content-Type": "application/json",
      },
    );
    print('');
  }

  final userdata = [
    User(
        name: '姓名', userName: UserSimplePreferences.getUserName(), edit: false),
    User(
      name: 'Email',
      userName: UserSimplePreferences.getUserEmail(),
      edit: false,
    ),
    User(
      name: '生日',
      userName: UserSimplePreferences.getUserBirthday() ?? '尚未設定',
      edit: true,
      correct: false,
    ),
    User(
      name: '手機號碼',
      userName: UserSimplePreferences.getUserPhone() ?? '尚未設定',
      edit: true,
      correct: true,
      verify: UserSimplePreferences.getPhoneVerify() ?? false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.height15),
                child: GestureDetector(
                  onTap: () async {},
                  child: Container(
                    height: Dimensions.height50,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          UserSimplePreferences.clearPreference();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                        child: BetweenSM(
                          color: Colors.red,
                          text: '刪除帳號',
                          fontFamily: 'NotoSansMedium',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: BetweenSM(
          color: kBodyTextColor,
          text: '個人檔案',
          fontFamily: 'NotoSansMedium',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: kMaimColor,
            size: Dimensions.icon25,
          ),
          onPressed: close,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                height: Dimensions.height5,
              ),
              Column(
                children: List.generate(
                  userdata.length,
                  (index) => UserCard(
                    name: userdata[index].name,
                    username: userdata[index].userName,
                    edit: userdata[index].edit,
                    correct: userdata[index].correct,
                    verify: userdata[index].verify,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  const User({
    required this.name,
    required this.userName,
    required this.edit,
    this.correct,
    this.verify,
  });
  final String name;
  final String? userName;
  final bool edit;
  final bool? correct;
  final bool? verify;
}
