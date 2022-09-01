import 'package:flutter/material.dart';

class RegisterSecondPage extends StatelessWidget {
  const RegisterSecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第二步-驗證碼'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text('輸入驗證碼完成註冊'),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              child: const Text('下一步'),
              onPressed: () {
                Navigator.pushNamed(context, '/registerthird');
                //Navigator.pushReplacementNamed(context,'/registerthird');
              },
            )
          ],
        ),
      ),
    );
  }
}
