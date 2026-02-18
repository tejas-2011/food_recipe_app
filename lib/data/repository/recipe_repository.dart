import '../local/database_helper.dart';
import '../models/recipe_model.dart';
import '../services/api/recipe_api_service.dart';

class RecipeRepository {
  final RecipeApiService _apiService = RecipeApiService();
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<RecipeModel>> getRecipesByIngredients(
    String query, {
    String? healthFilter,
  }) async {
    return await _apiService.getRecipes(query, diet: healthFilter);
  }

  Future<void> saveToFavorites(RecipeModel recipe) async {
    await _db.insertFavorite(recipe);
  }

  Future<List<RecipeModel>> fetchSavedRecipes() async {
    return await _db.getFavorites();
  }
}
