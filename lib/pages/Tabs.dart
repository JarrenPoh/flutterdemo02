import 'package:flutter/material.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutterdemo02/pages/Form3.dart';
import 'package:get/get.dart';

import '../componentsShopcar/emptyshopCar.dart';
import 'tabs/BookMarkPage.dart';

class Tabs extends StatefulWidget {
  //要接收Registerthird返回Tab時改變_currentIndex的值(才能回到Tab的Setting介面)
  final index;
  const Tabs({Key? key, this.index = 0}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState(index);
}

final cartController = Get.put(CartController());

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  //創建一個構造方法接收傳過來的新的Index
  _TabsState(index) {
    _currentIndex = index;
  }

  // List _pagelist = [
  //   HomePage(), //0
  //   MyHomePage(), //1
  //   SettingPage(), //2

  // ];

  final List _pagelist = [
    FormPage3(),
    BookMarkPage(
      arguments: const {"frg": 0},
    ), //1

    // shopCar(),

    //2
  ];
  final List _pagelist2 = [
    FormPage3(),
    BookMarkPage(
      arguments: const {"frg": 0},
    ), //1

    const emptyShopCar(),

    //2
  ];

  @override
  Widget build(BuildContext context) {
    final List Pagelist;
    if (cartController.cartlist.isEmpty) {
      Pagelist = _pagelist2;
    } else {
      Pagelist = _pagelist;
    }
    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Color.fromRGBO(254, 151, 99, 2),
      //     centerTitle: true,
      //     // ignore: prefer_const_constructors
      //     title: Text('Foodone(中原大學)',),
      //     actions: [
      //       IconButton(
      //         onPressed: (){
      //           showSearch(
      //             context: context,
      //             delegate:GitmeRebornSearchDelegate(dddShopNames:ShopNames , dddShopNamesSuggestion:ShopNamesSuggestion )) ;
      //         },
      //         icon: Icon(Icons.search,size:26,)
      //       )
      //     ],
      // ),

      body: Pagelist[
          _currentIndex], //3.currentindex數值換了，前面調用上面pagelist相對述職的page頁面
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, //2.重新渲染，下面藍藍的換成別的藍藍的
        onTap: (int index) {
          setState(() {
            _currentIndex = index; //1.點擊後currentindex的質改變，開始重新渲染
          });
        },
        iconSize: 35, //Icon的大小
        fixedColor: Colors.red, //選中時的顏色
        type: BottomNavigationBarType.fixed, //可以有多個NevagationButton
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ('首頁'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outlined),
            label: ('珍藏'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: ('訂單'),
          ),
        ],
      ),

      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       Row(
      //         children: [
      //           Expanded(
      //               child: UserAccountsDrawerHeader(
      //             accountName: Text(
      //               '傅子杰',
      //               style: TextStyle(fontSize: 16),
      //             ),
      //             accountEmail: Text("11028114"),
      //             currentAccountPicture: CircleAvatar(
      //               backgroundImage: NetworkImage(
      //                   "https://www.itying.com/images/flutter/2.png"),
      //             ),
      //             otherAccountsPictures: <Widget>[
      //               Icon(Icons.edit, color: Color.fromRGBO(255, 255, 255, 1)),
      //             ],
      //           )),
      //         ],
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.local_post_office_outlined,
      //           size: 32,
      //         ),
      //         title: Text("問題回報", style: TextStyle(fontSize: 18)),
      //       ),
      //       Divider(
      //         thickness: 5,
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.library_books_outlined,
      //           size: 32,
      //         ),
      //         title: Text("隱私條款", style: TextStyle(fontSize: 18)),
      //       ),
      //       Divider(
      //         thickness: 5,
      //       ),
      //       ListTile(
      //           leading: Icon(
      //             Icons.call_missed_outlined,
      //             size: 32,
      //           ),
      //           title: Text("登出", style: TextStyle(fontSize: 18)),
      //           onTap: () async {
      //             await showDialog(
      //                 context: context,
      //                 barrierDismissible: false,
      //                 builder: (context) => AlertDialog(
      //                       content: Text("你確定要登出當前帳號嗎"),
      //                       actions: [
      //                         TextButton(
      //                             onPressed: () => Navigator.pop(context),
      //                             child: Text('取消')),
      //                         TextButton(
      //                             onPressed: () =>
      //                                 Navigator.pushNamedAndRemoveUntil(context,
      //                                     '/login', ModalRoute.withName('/')),
      //                             child: Text('確定')),
      //                       ],
      //                     ));
      //           }),
      //       Divider(
      //         thickness: 5,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
