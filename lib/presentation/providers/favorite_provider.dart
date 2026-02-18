import 'package:flutter/material.dart';
import '../../data/local/database_helper.dart';
import '../../data/models/recipe_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<RecipeModel> _favorites = [];

  List<RecipeModel> get favorites => List.unmodifiable(_favorites);

  Future<void> loadFavorites() async {
    _favorites = await _db.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(RecipeModel recipe) async {
    if (isFavorite(recipe)) {
      await _db.deleteFavorite(recipe.label);
      _favorites.removeWhere((r) => r.label == recipe.label);
    } else {
      await _db.insertFavorite(recipe);
      _favorites.add(recipe);
    }
    notifyListeners();
  }

  bool isFavorite(RecipeModel recipe) {
    return _favorites.any((r) => r.label == recipe.label);
  }
}