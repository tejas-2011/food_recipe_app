import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import '../../../resources/constants/strings.dart';
import '../../../resources/constants/url_s.dart';
import '../../models/recipe_model.dart';

class AppService {
  Future<List<RecipeModel>> getRecipes(String query) async {
    final List<RecipeModel> recipeList = [];

    final appId = dotenv.env['FOOD_RECIPE_APP_ID']?.trim() ?? '';
    final appKey = dotenv.env['FOOD_RECIPE_APP_KEY']?.trim() ?? '';
    final userName = dotenv.env['EDAMAM_USER_NAME']?.trim() ?? '';

    final String url = UsedUrls.recipeUrl(query, appId, appKey);

    try {
      final Response response = await get(
        Uri.parse(url),
        headers: {
          AppConstants.usedAccount: userName,
        },
      );

      if (response.statusCode != 200) {
        log('API error: ${response.statusCode} – ${response.body}');
        return [];
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      for (final element in data['hits'] as List) {
        recipeList.add(RecipeModel.fromMap(element['recipe']));
      }

      log('Total recipes fetched: ${recipeList.length}');
    } catch (e, stackTrace) {
      log('Error fetching recipes', error: e, stackTrace: stackTrace);
    }

    return recipeList;
  }
}
