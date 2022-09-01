import 'package:flutter/material.dart';
import 'package:flutterdemo02/components3/components3_second/Search_Box.dart';

class SliverappbarForP3 extends StatelessWidget {
  SliverappbarForP3({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false, //隱藏drawer預設icon
      backgroundColor: Colors.white,
      expandedHeight: MediaQuery.of(context).size.height / 11,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: SearchBox(
          onTap: (() {
            Navigator.pushNamed(
              context,
              '/searchingpage',
            );
          }),
        ),
      ),

      pinned: false,
      floating: true,

      // flexibleSpace: FlexibleSpaceBar(
      //   centerTitle:
      // ),

      elevation: 0,
    );
  }
}
