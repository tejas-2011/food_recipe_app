import 'package:flutter/material.dart';
import '../../../data/models/recipe_model.dart';
import '../../../resources/constants/strings.dart';

class FoodItemsList extends StatelessWidget {
  final List<RecipeModel> recipeList;

  const FoodItemsList({super.key, required this.recipeList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipeList.length,
      itemBuilder: (context, index) {
        final RecipeModel recipe = recipeList[index];

        return InkWell(
          onTap: () {},
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 48, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: const BoxDecoration(color: Colors.black26),
                      child: Text(
                        recipe.label,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    height: 40,
                    width: 80,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${recipe.calories.toStringAsFixed(0)} ${AppConstants.calorieUnit}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
