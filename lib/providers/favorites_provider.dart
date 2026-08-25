import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<String, Product> _favorites = {};

  Map<String, Product> get favorites => {
        ..._favorites,
      };

  bool isFavorite(String productId) {
    return _favorites.containsKey(productId);
  }

  void toggleFavorite(Product product) {
    if (_favorites.containsKey(product.id)) {
      _favorites.remove(product.id);
    } else {
      _favorites[product.id] = product;
    }

    notifyListeners();
  }

  void removeFavorite(String productId) {
    _favorites.remove(productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}