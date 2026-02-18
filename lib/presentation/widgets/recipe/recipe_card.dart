import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/recipe_model.dart';
import '../../providers/favorite_provider.dart';
import '../../screens/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final bool isFavorited = favoriteProvider.isFavorite(recipe);

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.network(
                          recipe.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(Icons.restaurant,
                                color: AppColors.textLight),
                          ),
                        ),
                      ),
                      if (recipe.difficulty != null)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  Helpers.getDifficultyColor(recipe.difficulty!)
                                      .withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              recipe.difficulty!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          radius: 18,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: isFavorited
                                  ? Colors.red
                                  : AppColors.textLight,
                            ),
                            onPressed: () async {
                              await favoriteProvider.toggleFavorite(recipe);
                              if (context.mounted) {
                                isFavorited
                                    ? Helpers.showErrorSnackbar(
                                        context, 'Removed from Favorites')
                                    : Helpers.showSuccessSnackbar(
                                        context, 'Added to Favorites');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                  child: Text(
                    recipe.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      if (recipe.totalTime != null && recipe.totalTime! > 0)
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 12, color: AppColors.textLight),
                            const SizedBox(width: 3),
                            Text(
                              Helpers.formatTime(recipe.totalTime!),
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      const Icon(Icons.local_fire_department,
                          size: 12, color: AppColors.accent),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '${recipe.calories.toStringAsFixed(0)} kcal',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
