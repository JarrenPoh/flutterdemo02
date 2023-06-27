import 'package:flutter/material.dart';
import 'package:flutterdemo02/pages/user/RegisterSecond.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';

class RegisterFirstPage extends StatelessWidget {
  const RegisterFirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('註冊一'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text('這是註冊的第一步，請輸入你的手機號，然後點擊下一步'),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              child: const Text('下一步'),
              onPressed: () {
                Navigator.push(
                  context,
                  CustomPageRoute(
                    child: RegisterSecondPage(),
                  ),
                );
                //Navigator.pushReplacementNamed(context,'/registersecond');
              },
            )
          ],
        ),
      ),
    );
  }
}
