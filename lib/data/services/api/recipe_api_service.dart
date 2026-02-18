import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/recipe_model.dart';

class RecipeApiService {
  final String baseUrl = "https://api.edamam.com/api/recipes/v2";

  Future<List<RecipeModel>> getRecipes(String query, {String? diet}) async {
    final appId    = dotenv.env['FOOD_RECIPE_APP_ID']?.trim()  ?? '';
    final appKey   = dotenv.env['FOOD_RECIPE_APP_KEY']?.trim() ?? '';
    final userName = dotenv.env['EDAMAM_USER_NAME']?.trim()    ?? '';

    String url = "$baseUrl?type=public&q=${Uri.encodeComponent(query)}"
        "&app_id=$appId"
        "&app_key=$appKey";

    if (diet != null && diet.toLowerCase() != 'all') {
      url += "&health=$diet";
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Edamam-Account-User': userName,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List hits = data['hits'] ?? [];
        return hits.map((element) {
          return RecipeModel.fromMap(element['recipe']);
        }).toList();
      } else {
        throw Exception("Failed to load recipes: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}