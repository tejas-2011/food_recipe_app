import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/services/api/service.dart';
import '../../../resources/constants/strings.dart';

class AppSearchBar extends StatefulWidget {
  final Function(List<RecipeModel>) onRecipesLoaded;

  const AppSearchBar({super.key, required this.onRecipesLoaded});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _searchController;
  final AppService _service = AppService();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final List<RecipeModel> recipes = await _service.getRecipes(query);
      if (mounted) {
        widget.onRecipesLoaded(recipes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.searchBarColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: AppConstants.searchHintText,
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          GestureDetector(
            onTap: _performSearch,
            child: _isSearching
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
