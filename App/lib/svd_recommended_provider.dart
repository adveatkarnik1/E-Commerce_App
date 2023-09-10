import 'package:flutter/material.dart';

class SVDRecommendedProduct {
  final int id;

  SVDRecommendedProduct({
    required this.id,
  });
}

class SVDRecommendedProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<SVDRecommendedProduct> _items = [];

  List<SVDRecommendedProduct> get items {
    return _items;
  }

  int get numOfItems => _items.length;

  bool areProductsBeingRecommended() {
    if (_items.isEmpty) {
      return false;
    }
    return true;
  }

  void addItem(
    int id,
  ) {
    _items.add(
      SVDRecommendedProduct(
        id: id,
      ),
    );
    notifyListeners();
  }
}
