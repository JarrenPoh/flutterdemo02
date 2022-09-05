import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../API/StoreModel.dart';

final placeResultsProvider = ChangeNotifierProvider<PlaceResults>((ref) {
  return PlaceResults();
});

final searchToggleProvider = ChangeNotifierProvider<SearchToggle>((ref) {
  return SearchToggle();
});

class PlaceResults extends ChangeNotifier {
  List<Result?>? allReturnResults = [];

  void setResult(allPlace) {
    allReturnResults = allPlace;
    notifyListeners();
  }
}

class SearchToggle extends ChangeNotifier {
  bool? searchToggle;

  void toggleSearch(bool v) {
    searchToggle = v;
    
    
    notifyListeners();
  }
}
