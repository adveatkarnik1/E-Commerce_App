import 'package:flutter/material.dart';

class LLMRecommendedCategory {
  final String category;

  LLMRecommendedCategory({
    required this.category,
  });
}

class LLMRecommendedProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<LLMRecommendedCategory> _items = [];

  List<LLMRecommendedCategory> get items {
    return _items;
  }

  int get numOfItems => _items.length;

  bool areCategorysBeingRecommended() {
    if (_items.isEmpty) {
      return false;
    }
    return true;
  }

  void addItem(
    String category,
  ) {
    _items.add(
      LLMRecommendedCategory(
        category: category,
      ),
    );
    notifyListeners();
  }

  void clear() {
    _items.clear();
  }
}
