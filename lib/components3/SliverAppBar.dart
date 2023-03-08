import 'package:flutter/material.dart';
import 'package:flutterdemo02/components3/components3_second/Search_Box.dart';
import 'package:flutterdemo02/pages/SearchingPage.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';

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
            Navigator.push(
              context,
              CustomPageRoute(
                child: SearchingPage(),
              ),
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
