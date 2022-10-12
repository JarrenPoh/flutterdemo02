import 'package:flutter/material.dart';
import 'package:flutterdemo02/pages/Tabs.dart';

class RegisterThirdPage extends StatelessWidget {
  const RegisterThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第三步-完成註冊'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text('輸入密碼完成註冊'),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              child: const Text('確定'),
              onPressed: () {
                //Navigator.of(context).pop();
                //返回根
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const Tabs(
                              index: 2,
                            )),
                    (route) => route == null);
              },
            )
          ],
        ),
      ),
    );
  }
}
