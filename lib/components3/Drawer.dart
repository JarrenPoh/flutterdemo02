import 'package:flutter/material.dart';
import 'package:flutterdemo02/components3/components3_second/image_map.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/pages/login.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: kMaim3Color),
                  accountName: TabText(
                      color: Colors.white,
                      text: '${UserSimplePreferences.getUserName()}'),
                  accountEmail: TabText(
                      color: Colors.white,
                      text: '${UserSimplePreferences.getUserEmail()}'),
                  currentAccountPicture: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            '${UserSimplePreferences.getUserPicture()}'),
                      ),
                    ),
                  ),
                  // otherAccountsPictures: const <Widget>[
                  //   Icon(Icons.edit, color: Color.fromRGBO(255, 255, 255, 1)),
                  // ],
                ),
              ),
            ],
          ),
          ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/history',
                );
              },
              leading: Icon(
                Icons.next_week_outlined,
                size: Dimensions.fontsize24,
              ),
              title: BetweenSM(
                color: kBodyTextColor,
                text: '歷史訂單',
              )),
          ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/userprofile',
                );
              },
              leading: Icon(
                Icons.person_outlined,
                size: Dimensions.fontsize24,
              ),
              title: BetweenSM(
                color: kBodyTextColor,
                text: '個人檔案',
              )),
          ListTile(

            onTap: (() => Navigator.pushNamed(context, '/email',)),

              leading: Icon(
                Icons.local_post_office_outlined,
                size: Dimensions.fontsize24,
              ),
              title: BetweenSM(
                color: kBodyTextColor,
                text: '問題回報',
              )),
          ListTile(
            onTap: (() => Navigator.pushNamed(context, '/privacy')),

              leading: Icon(
                Icons.library_books_outlined,
                size: Dimensions.fontsize24,
              ),
              title: BetweenSM(
                color: kBodyTextColor,
                text: '隱私條款',
              )),
          ListTile(
            leading: Icon(
              Icons.call_missed_outlined,
              size: Dimensions.fontsize24,
            ),
            title: BetweenSM(
              color: kBodyTextColor,
              text: '登出',
            ),
            onTap: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  content: const Text("你確定要登出當前帳號嗎"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消')),
                    TextButton(
                      onPressed: () async {
                        await GoogleSignInApi.logout;
                        Navigator.pushReplacementNamed(
                          context,
                          '/login',
                        );
                      },
                      child: const Text('確定'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
