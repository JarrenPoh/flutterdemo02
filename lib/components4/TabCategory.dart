import 'package:flutter/material.dart';
import 'package:flutterdemo02/components4/rappic_bloc.dart';
import 'package:flutterdemo02/models/TabsText.dart';

import '../models/ColorSettings.dart';

class RappidTabWidget extends StatelessWidget {
  const RappidTabWidget(this.tabcategory);
  final RappiTabCategory tabcategory;

  @override
  Widget build(BuildContext context) {
    final selected = tabcategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation: selected ? 6 : 0,
        child: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: TabText(
              color: selected ? kMaimColor : kBodyTextColor,
              text: tabcategory.category,
              weight: selected ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    );
  }
}
