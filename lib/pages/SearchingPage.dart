import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/StoreModel.dart';
import 'package:flutterdemo02/models/BetweenSM.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:get/get.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../API/searchApi.dart';
import '../controllers/cart_controller.dart';
import '../provider/Shared_Preference.dart';
import 'SearchWidget.dart';

class SearchingPage extends StatefulWidget {
  SearchingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  Future init() async {
    originbooks =
        await BookApi.getStores(query, UserSimplePreferences.getToken());
    if (originbooks == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      originbooks =
          await BookApi.getStores(query, UserSimplePreferences.getToken());
    }
    debugPrint('${originbooks}');
    setState(() {
      this.books = originbooks!;
    });
  }

  void debounce(VoidCallback callback,
      {Duration duration = const Duration(microseconds: 100)}) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Timer? debouncer;
  var bookbool = true;
  final cartController = Get.put(CartController());
  String query = '';
  List<Result?>? books = [];
  List<Result?>? originbooks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearch(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: Dimensions.height20 * 1.6,
            height: Dimensions.height20 * 1.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20 * 2),
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
      body: Padding(
        padding: EdgeInsets.only(top: Dimensions.height10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: books!.length,
                itemBuilder: ((context, index) {
                  final book = books![index];

                  return buildCard(book!);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Result book) {
    if (book.image != null) {
      bookbool = true;
    } else {
      bookbool = false;
    }
    return ListTile(
      leading: bookbool
          ? Image.asset(
              book.image!,
              fit: BoxFit.cover,
              width: Dimensions.width15 * 6,
            )
          : Container(
              color: Colors.grey,
              width: Dimensions.width15 * 6,
            ),
      trailing: Icon(
        Icons.search,
        size: Dimensions.height10 * 2,
      ),
      title: BetweenSM(
        color: kBodyTextColor,
        text: book.name!,
        fontFamily: 'NotoSansMedium',
      ),
      subtitle: TabText(
        color: kTextLightColor,
        text: book.address!,
      ),
      onTap: () async {
        if (cartController.cartlist.isNotEmpty &&
            cartController.cartlist.first.shopname != book.name) {
          bool? delete = await showDeleteDialod();
          if (delete == false) {
            cartController.deleteAll();
            Navigator.pushNamed(context, '/form4', arguments: {
              'shopname': book.name,
              'shopimage': book.image,
              'discount': jsonDecode(book.discount!),
              'id': book.id,
              'businessTime': book.businessTime,
              'timeEstimate': book.timeEstimate,
              'describe': book.describe,
            });
          }
        } else {
          Navigator.pushNamed(context, '/form4', arguments: {
            'shopname': book.name,
            'shopimage': book.image,
            'discount': jsonDecode(book.discount!),
            'id': book.id,
            'businessTime': book.businessTime,
            'timeEstimate': book.timeEstimate,
            'describe': book.describe,
          });
        }
      },
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: '輸入店家名稱或地址',
        onChanged: searchBook,
      );
  void searchBook(String query) async => debounce(() async {
        List<Result?>? book = this.originbooks!.where((e) {
          final titleLower = e!.name.toString().toLowerCase();
          final addressLower = e.address.toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return titleLower.contains(searchLower) ||
              addressLower.contains(searchLower);
        }).toList();

        setState(() {
          this.query = query;
          this.books = book;
        });
      });

  Future<bool?> showDeleteDialod() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text('您選擇了不同餐廳，確認是否清除目前購物車內容'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('確認'),
            ),
          ],
        );
      },
    );
  }
}
