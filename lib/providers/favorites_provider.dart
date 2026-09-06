import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/firestore_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<String, Product> _favorites = {};

  // Used to prevent an old Firebase load from overwriting
  // a newer local favorite change.
  int _favoritesVersion = 0;

  Map<String, Product> get favorites => {
        ..._favorites,
      };

  bool isFavorite(String productId) {
    return _favorites.containsKey(productId);
  }

  // =========================
  // LOAD FAVORITES
  // =========================

  Future<void> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _favorites.clear();
      notifyListeners();
      return;
    }

    // Remember the state of favorites when this request starts.
    final requestVersion = _favoritesVersion;

    try {
      final products = await FirestoreService.fetchFavorites(
        user.uid,
      );

      // If user changed favorites while Firebase was loading,
      // do NOT overwrite the newer local state.
      if (requestVersion != _favoritesVersion) {
        return;
      }

      _favorites
        ..clear()
        ..addEntries(
          products.map(
            (product) => MapEntry(
              product.id,
              product,
            ),
          ),
        );

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // =========================
  // TOGGLE FAVORITE
  // =========================

  Future<void> toggleFavorite(Product product) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final wasFavorite = _favorites.containsKey(product.id);

    // Mark this as a newer local change.
    _favoritesVersion++;

    // Update UI immediately.
    if (wasFavorite) {
      _favorites.remove(product.id);
    } else {
      _favorites[product.id] = product;
    }

    notifyListeners();

    try {
      if (wasFavorite) {
        await FirestoreService.removeFavorite(
          user.uid,
          product.id,
        );
      } else {
        await FirestoreService.saveFavorite(
          user.uid,
          product,
        );
      }
    } catch (e) {
      // Firebase operation failed.
      // Roll back the local UI state.

      _favoritesVersion++;

      if (wasFavorite) {
        _favorites[product.id] = product;
      } else {
        _favorites.remove(product.id);
      }

      notifyListeners();

      debugPrint('Error updating favorite: $e');
    }
  }

  // =========================
  // REMOVE FAVORITE
  // =========================

  Future<void> removeFavorite(String productId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final product = _favorites[productId];

    _favoritesVersion++;

    _favorites.remove(productId);
    notifyListeners();

    try {
      await FirestoreService.removeFavorite(
        user.uid,
        productId,
      );
    } catch (e) {
      _favoritesVersion++;

      if (product != null) {
        _favorites[productId] = product;
      }

      notifyListeners();

      debugPrint('Error removing favorite: $e');
    }
  }

  // =========================
  // CLEAR FAVORITES
  // =========================

  Future<void> clearFavorites() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final oldFavorites = Map<String, Product>.from(
      _favorites,
    );

    _favoritesVersion++;

    _favorites.clear();
    notifyListeners();

    try {
      for (final productId in oldFavorites.keys) {
        await FirestoreService.removeFavorite(
          user.uid,
          productId,
        );
      }
    } catch (e) {
      _favoritesVersion++;

      _favorites
        ..clear()
        ..addAll(oldFavorites);

      notifyListeners();

      debugPrint('Error clearing favorites: $e');
    }
  }
}