import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../resources/constants/strings.dart';

class DietaryFilterChips extends StatelessWidget {
  final String? selectedDiet;
  final Function(String?) onDietSelected;

  const DietaryFilterChips({
    super.key,
    this.selectedDiet,
    required this.onDietSelected,
  });

  static final List<Map<String, dynamic>> dietOptions = [
    {'label': 'All', 'value': null, 'icon': Icons.restaurant},
    {'label': AppConstants.vegetarian, 'value': 'vegetarian', 'icon': Icons.eco},
    {'label': AppConstants.vegan, 'value': 'vegan', 'icon': Icons.spa},
    {'label': AppConstants.glutenFree, 'value': 'gluten-free', 'icon': Icons.grain},
    {'label': AppConstants.keto, 'value': 'keto-friendly', 'icon': Icons.fire_extinguisher},
    {'label': AppConstants.paleo, 'value': 'paleo', 'icon': Icons.fitness_center},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dietOptions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = dietOptions[index];
          final isSelected = selectedDiet == option['value'];

          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  option['icon'] as IconData,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(option['label'] as String),
              ],
            ),
            onSelected: (selected) {
              onDietSelected(selected ? option['value'] : null);
            },
            backgroundColor: Colors.white,
            selectedColor: AppColors.primary,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.textLight,
              ),
            ),
          );
        },
      ),
    );
  }
}