import 'package:flutter/material.dart';

import 'model.dart';

class CartProduct {
  final String id;
  final String title;
  final String des;
  final String image;
  final double ratings;
  final int offer;
  final int price;
  final int category;
  final String subcategory;

  CartProduct({
    required this.id,
    required this.title,
    required this.des,
    required this.image,
    required this.ratings,
    required this.offer,
    required this.price,
    required this.category,
    required this.subcategory,
  });
}

class CartProvider with ChangeNotifier {
  List<CartProduct> _items = [];

  List<CartProduct> get items {
    return _items;
  }

  int get numOfItems => _items.length;

  void addItem(
    Model model,
  ) {
    _items.add(
      CartProduct(
        id: model.id,
        title: model.title,
        price: model.price,
        image: model.img,
        category: model.category,
        des: model.des,
        offer: model.offer,
        subcategory: model.subcategory,
        ratings: model.ratings,
      ),
    );
    notifyListeners();
  }

  void delItem(CartProduct product) {
    _items.remove(product);
    notifyListeners();
  }

  clearCart() {
    _items = [];
    notifyListeners();
  }
}
