import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final Map<ProductModel, int> _items = {};

  Map<ProductModel, int> get items => _items;

  void addToCart(ProductModel product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void remove(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }

  void increase(ProductModel product) {
    _items[product] = _items[product]! + 1;
    notifyListeners();
  }

  void decrease(ProductModel product) {
    if (_items[product]! > 1) {
      _items[product] = _items[product]! - 1;
    } else {
      _items.remove(product);
    }
    notifyListeners();
  }

  int get total {
    int total = 0;
    _items.forEach((p, qty) {
      total += (p.price ?? 0).toInt() * qty;
    });
    return total;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}