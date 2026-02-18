import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/recipe_model.dart';
import '../../../core/utils/helpers.dart';
import '../providers/favorite_provider.dart';
import 'recipe_view_page.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late int _servings;
  late int _baseServings;


  static const Map<String, List<String>> _substitutions = {
    'butter': ['olive oil', 'coconut oil', 'Greek yogurt'],
    'milk': ['almond milk', 'oat milk', 'coconut milk'],
    'egg': ['flax egg (1 tbsp flaxseed + 3 tbsp water)', 'chia egg', 'applesauce (¼ cup)'],
    'flour': ['almond flour', 'oat flour', 'rice flour'],
    'sugar': ['honey', 'maple syrup', 'coconut sugar'],
    'cream': ['coconut cream', 'evaporated milk', 'Greek yogurt'],
    'sour cream': ['Greek yogurt', 'crème fraîche', 'cottage cheese'],
    'mayonnaise': ['Greek yogurt', 'avocado', 'hummus'],
    'breadcrumbs': ['rolled oats', 'crushed crackers', 'almond meal'],
    'chicken broth': ['vegetable broth', 'water + soy sauce', 'mushroom broth'],
    'beef': ['mushrooms (portobello)', 'lentils', 'jackfruit'],
    'chicken': ['tofu', 'chickpeas', 'cauliflower'],
    'parmesan': ['nutritional yeast', 'pecorino romano', 'grana padano'],
    'olive oil': ['avocado oil', 'canola oil', 'butter'],
    'lemon juice': ['lime juice', 'white wine vinegar', 'apple cider vinegar'],
    'honey': ['maple syrup', 'agave nectar', 'brown sugar'],
    'soy sauce': ['tamari (gluten-free)', 'coconut aminos', 'worcestershire sauce'],
    'heavy cream': ['coconut cream', 'cashew cream', 'evaporated milk'],
    'bacon': ['turkey bacon', 'smoked tempeh', 'prosciutto'],
    'white wine': ['chicken broth', 'apple juice', 'white grape juice'],
  };

  @override
  void initState() {
    super.initState();
    _baseServings = widget.recipe.yield ?? 1;
    _servings = _baseServings;
  }

  double get _scale => _servings / _baseServings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(),
                  const SizedBox(height: 16),
                  _buildQuickInfoRow(),
                  const SizedBox(height: 24),
                  _buildServingStepper(),
                  const SizedBox(height: 24),
                  _buildNutritionSection(),
                  const SizedBox(height: 24),
                  _buildIngredientsSection(),
                  _buildSubstitutionsSection(),
                  const SizedBox(height: 24),
                  _buildViewRecipeButton(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sliver App Bar with hero image ───────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primary, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [_buildFavoriteButton(context)],
      flexibleSpace: FlexibleSpaceBar(
        background: widget.recipe.imageUrl.isNotEmpty
            ? Image.network(
          widget.recipe.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surfaceVariant,
            child: const Icon(Icons.restaurant,
                size: 64, color: AppColors.textLight),
          ),
        )
            : Container(
          color: AppColors.surfaceVariant,
          child: const Icon(Icons.restaurant,
              size: 64, color: AppColors.textLight),
        ),
      ),
    );
  }

  // ─── Favorite toggle button ────────────────────────────────────────────────

  Widget _buildFavoriteButton(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, _) {
        final bool isFav = favoriteProvider.isFavorite(widget.recipe);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : AppColors.textLight,
                size: 20,
              ),
              onPressed: () async {
                await favoriteProvider.toggleFavorite(widget.recipe);
                if (context.mounted) {
                  isFav
                      ? Helpers.showErrorSnackbar(
                      context, 'Removed from Favorites')
                      : Helpers.showSuccessSnackbar(
                      context, 'Added to Favorites');
                }
              },
            ),
          ),
        );
      },
    );
  }

  // ─── Recipe title ──────────────────────────────────────────────────────────

  Widget _buildTitleRow() {
    return Text(
      widget.recipe.label,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  // ─── Quick info chips ──────────────────────────────────────────────────────

  Widget _buildQuickInfoRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (widget.recipe.totalTime != null && widget.recipe.totalTime! > 0)
          _InfoChip(
            icon: Icons.access_time,
            label: Helpers.formatTime(widget.recipe.totalTime!),
          ),
        if (widget.recipe.difficulty != null)
          _InfoChip(
            icon: Icons.bar_chart,
            label: widget.recipe.difficulty!,
            color: Helpers.getDifficultyColor(widget.recipe.difficulty!),
          ),
        _InfoChip(
          icon: Icons.local_fire_department,
          label: Helpers.formatCalories(widget.recipe.calories * _scale),
          color: AppColors.accent,
        ),
      ],
    );
  }

  // ─── Serving size stepper ─────────────────────────────────────────────────

  Widget _buildServingStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.people, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Servings',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '$_servings serving${_servings == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _StepperButton(
                icon: Icons.remove,
                onTap: _servings > 1
                    ? () => setState(() => _servings--)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_servings',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add,
                onTap: _servings < 20
                    ? () => setState(() => _servings++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Nutrition cards (scaled by serving multiplier) ────────────────────────

  Widget _buildNutritionSection() {
    final double protein =
        _getNutrientValue(widget.recipe.totalNutrients, 'PROCNT') * _scale;
    final double fat =
        _getNutrientValue(widget.recipe.totalNutrients, 'FAT') * _scale;
    final double carbs =
        _getNutrientValue(widget.recipe.totalNutrients, 'CHOCDF') * _scale;
    final double fiber =
        _getNutrientValue(widget.recipe.totalNutrients, 'FIBTG') * _scale;
    final double scaledCalories = widget.recipe.calories * _scale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition for $_servings serving${_servings == 1 ? '' : 's'}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _NutritionCard(
                label: 'Calories',
                value: scaledCalories.toStringAsFixed(0),
                unit: 'kcal',
                color: AppColors.accent),
            const SizedBox(width: 10),
            _NutritionCard(
                label: 'Protein',
                value: protein.toStringAsFixed(1),
                unit: 'g',
                color: AppColors.primary),
            const SizedBox(width: 10),
            _NutritionCard(
                label: 'Fat',
                value: fat.toStringAsFixed(1),
                unit: 'g',
                color: AppColors.secondary),
            const SizedBox(width: 10),
            _NutritionCard(
                label: 'Carbs',
                value: carbs.toStringAsFixed(1),
                unit: 'g',
                color: AppColors.info),
          ],
        ),
        if (fiber > 0) ...[
          const SizedBox(height: 8),
          Text(
            'Dietary fiber: ${fiber.toStringAsFixed(1)} g',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ],
    );
  }

  double _getNutrientValue(Map<String, dynamic> nutrients, String key) {
    try {
      final nutrient = nutrients[key];
      if (nutrient == null) return 0.0;
      return (nutrient['quantity'] as num?)?.toDouble() ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  // ─── Ingredients list (quantities scaled by serving multiplier) ───────────

  Widget _buildIngredientsSection() {
    if (widget.recipe.ingredientLines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.recipe.ingredientLines.map(
              (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6, right: 10),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    _scaleIngredientLine(item, _scale),
                    style: const TextStyle(
                        fontSize: 15, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_servings != _baseServings)
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Quantities scaled for $_servings serving${_servings == 1 ? '' : 's'}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.primary),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Scales the leading numeric quantity in an ingredient line string.
  /// e.g. "2 cups flour" × 1.5  →  "3.0 cups flour"
  String _scaleIngredientLine(String line, double scale) {
    if (scale == 1.0) return line;
    final numericPattern = RegExp(r'^(\d+\.?\d*)\s*');
    final match = numericPattern.firstMatch(line);
    if (match != null) {
      final original = double.tryParse(match.group(1) ?? '');
      if (original != null) {
        final scaled = original * scale;
        final formatted = scaled == scaled.roundToDouble()
            ? scaled.toInt().toString()
            : scaled.toStringAsFixed(1);
        return line.replaceFirst(match.group(0)!, '$formatted ');
      }
    }
    return line;
  }

  // ─── Substitution suggestions ─────────────────────────────────────────────

  Widget _buildSubstitutionsSection() {
    final Map<String, List<String>> found = {};
    for (final line in widget.recipe.ingredientLines) {
      final lower = line.toLowerCase();
      for (final entry in _substitutions.entries) {
        if (lower.contains(entry.key) && !found.containsKey(entry.key)) {
          found[entry.key] = entry.value;
        }
      }
    }
    if (found.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Row(
          children: [
            Icon(Icons.swap_horiz, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Substitution Suggestions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Run out of an ingredient? Try these alternatives:',
          style:
          TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        ...found.entries.map(
              (entry) => _SubstitutionCard(
            ingredient: entry.key,
            substitutes: entry.value,
          ),
        ),
      ],
    );
  }

  // ─── View Full Recipe button → WebView ────────────────────────────────────

  Widget _buildViewRecipeButton(BuildContext context) {
    if (widget.recipe.url.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeViewPage(url: widget.recipe.url),
            ),
          );
        },
        icon: const Icon(Icons.open_in_browser, color: Colors.white),
        label: const Text(
          'View Full Recipe & Instructions',
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

// ─── Reusable sub-widgets ─────────────────────────────────────────────────

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _SubstitutionCard extends StatefulWidget {
  final String ingredient;
  final List<String> substitutes;

  const _SubstitutionCard({
    required this.ingredient,
    required this.substitutes,
  });

  @override
  State<_SubstitutionCard> createState() => _SubstitutionCardState();
}

class _SubstitutionCardState extends State<_SubstitutionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: AppColors.primary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.kitchen,
                        size: 16, color: AppColors.secondaryDark),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Instead of ${widget.ingredient}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.surfaceVariant),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.substitutes
                    .map(
                      (sub) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                          AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Text(
                      sub,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                color: chipColor,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _NutritionCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                  fontSize: 10, color: color.withOpacity(0.8)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}