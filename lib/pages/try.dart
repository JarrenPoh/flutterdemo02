import 'package:flutter/material.dart';

class trytrycan extends StatefulWidget {
  trytrycan({Key? key}) : super(key: key);

  @override
  State<trytrycan> createState() => _trytrycanState();
}

class _trytrycanState extends State<trytrycan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.blue,
          width: 100,
          height: 100,
          child: Column(
            children: [
              Container(
                color: Colors.red,
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
