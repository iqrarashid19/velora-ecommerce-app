import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/cart_item.dart';
import 'package:e_commerce_app/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {
        ..._items,
      };

  int get itemCount {
    return _items.values.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  double get totalAmount {
    return _items.values.fold(
      0,
      (total, item) => total + item.totalPrice,
    );
  }

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(
        product: product,
      );
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void deleteFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}