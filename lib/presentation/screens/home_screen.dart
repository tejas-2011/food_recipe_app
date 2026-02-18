import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core_utils/image_helper.dart';
import '../../../data/services/ai/ai_service.dart';
import '../../../resources/constants/app_constants.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../state/recipe_state.dart';
import '../providers/favorite_provider.dart';
import '../widgets/common/app_bar.dart';
import '../widgets/common/category_scroll.dart';
import '../widgets/common/custom_search_bar.dart';
import '../widgets/common/dietry_filter_chips.dart';
import '../widgets/recipe/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  String? _selectedDiet;
  final AIService _aiService = AIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: TasteAtlasAppBar(
        title: _selectedNavIndex == 0
            ? AppConstants.appName
            : (_selectedNavIndex == 1 ? 'Favorites' : 'Profile'),
        showBackButton: _selectedNavIndex != 0,
        onBackPress: () => setState(() => _selectedNavIndex = 0),
      ),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildFavoritesTab();
      case 2:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  // ─── Home Tab ──────────────────────────────────────────────────────────────

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              onSearch: (query) {
                context.read<RecipeBloc>().add(
                  RecipeEvent(query, diet: _selectedDiet),
                );
              },
              onFilterTap: () => _showFilterBottomSheet(context),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildImageSearchButton(),
          ),
        ),
        SliverToBoxAdapter(
          child: DietaryFilterChips(
            selectedDiet: _selectedDiet,
            onDietSelected: (diet) => setState(() => _selectedDiet = diet),
          ),
        ),
        const SliverToBoxAdapter(child: CategoryScroll()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Recipes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        'Finding delicious recipes...',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is RecipeLoaded) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                        RecipeCard(recipe: state.recipes[index]),
                    childCount: state.recipes.length,
                  ),
                ),
              );
            }

            if (state is RecipeError) {
              return SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off,
                            size: 64, color: AppColors.textLight),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<RecipeBloc>().add(
                              RecipeEvent('chicken', diet: _selectedDiet),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Initial state
            return const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu,
                        size: 80, color: AppColors.textLight),
                    SizedBox(height: 16),
                    Text(
                      AppConstants.startCooking,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildImageSearchButton() {
    return OutlinedButton.icon(
      onPressed: () => _showImageSourcePicker(context),
      icon: const Icon(Icons.camera_alt, color: AppColors.primary),
      label: const Text(
        'Search by Photo',
        style: TextStyle(color: AppColors.primary),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  void _showImageSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Identify Ingredients',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Take a photo or choose from gallery to identify ingredients',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _ImageSourceButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickAndRecognize(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ImageSourceButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickAndRecognize(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndRecognize(ImageSource source) async {
    final File? image = await ImageHelper.pickImage(source);
    if (image == null) return;
    if (!mounted) return;

    Helpers.showLoadingDialog(context, message: '🤖 Gemini is identifying ingredients...');

    try {
      final List<String> ingredients = await _aiService.recognizeIngredients(image);
      if (!mounted) return;
      Helpers.hideLoadingDialog(context);

      if (ingredients.isEmpty) {
        _showManualSearchDialog(hint: '');
        return;
      }

      // Show detected ingredients to user — let them confirm or edit
      _showIngredientsConfirmDialog(ingredients);

    } catch (e) {
      if (!mounted) return;
      Helpers.hideLoadingDialog(context);
      // If API key missing or network error, fall back to manual
      _showManualSearchDialog(hint: '', errorMessage: e.toString());
    }
  }

  /// Shows detected ingredients with chip UI — user can deselect and search
  void _showIngredientsConfirmDialog(List<String> detected) {
    final selected = List<bool>.filled(detected.length, true);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text('Ingredients Found!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tap to deselect any ingredient:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(detected.length, (i) {
                  return FilterChip(
                    label: Text(detected[i]),
                    selected: selected[i],
                    onSelected: (val) => setDialogState(() => selected[i] = val),
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected[i] ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: selected[i] ? AppColors.primary : AppColors.textLight,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showManualSearchDialog(hint: detected.join(', '));
              },
              child: const Text('Edit Manually'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final query = detected
                    .asMap()
                    .entries
                    .where((e) => selected[e.key])
                    .map((e) => e.value)
                    .join(' ');
                Navigator.pop(ctx);
                if (query.isNotEmpty) {
                  Helpers.showInfoSnackbar(context, 'Searching: $query');
                  context.read<RecipeBloc>().add(
                    RecipeEvent(query, diet: _selectedDiet),
                  );
                }
              },
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Find Recipes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Manual fallback dialog — shown when AI can't detect or user wants to edit
  void _showManualSearchDialog({required String hint, String? errorMessage}) {
    final TextEditingController controller = TextEditingController(text: hint);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Search by Ingredient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Could not detect ingredients. Type them below:',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'e.g. carrot, chicken, tomato',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final query = controller.text.trim();
              Navigator.pop(ctx);
              if (query.isNotEmpty) {
                context.read<RecipeBloc>().add(
                  RecipeEvent(query, diet: _selectedDiet),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  // ─── Favourites Tab ────────────────────────────────────────────────────────

  Widget _buildFavoritesTab() {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        if (favoriteProvider.favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border,
                    size: 64, color: AppColors.textLight),
                SizedBox(height: 16),
                Text(
                  AppConstants.noFavorites,
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 18),
                ),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: favoriteProvider.favorites.length,
          itemBuilder: (context, index) {
            return RecipeCard(recipe: favoriteProvider.favorites[index]);
          },
        );
      },
    );
  }

  // ─── Profile Tab ── UPDATED with "Made by Tejaswini" ──────────────────────

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 48,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // App name
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              AppConstants.appTagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 40),

            // Divider
            const Divider(color: AppColors.surfaceVariant),

            const SizedBox(height: 24),

            // Made by card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Made with ❤️ by',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tejaswini',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Version info
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Navigation Bar ─────────────────────────────────────────────────

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(color: AppColors.surfaceVariant, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // ─── Filter bottom sheet ───────────────────────────────────────────────────

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Filters coming soon...'),
      ),
    );
  }
}

// ─── Helper widget for image source picker ────────────────────────────────

class _ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}