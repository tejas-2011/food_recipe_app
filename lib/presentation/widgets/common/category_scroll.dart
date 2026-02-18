import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../resources/constants/assets_constants.dart';

class CategoryScroll extends StatelessWidget {
  const CategoryScroll({super.key});

  static final List<Map<String, String>> categories = [
    {
      'name': 'Indian',
      'image': AssetsConstants.indianCuisineImage,
    },
    {
      'name': 'Chinese',
      'image': AssetsConstants.chineseCuisineImage,
    },
    {
      'name': 'Italian',
      'image': AssetsConstants.italianCuisineImage,
    },
    {
      'name': 'Mexican',
      'image': AssetsConstants.mexicanCuisineImage,
    },
    {
      'name': 'Japanese',
      'image': AssetsConstants.japaneseCuisineImage,
    },
    {
      'name': 'Korean',
      'image': AssetsConstants.koreanCuisineImage,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Explore Cuisines',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryCard(
                name: category['name']!,
                imageUrl: category['image']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _CategoryCard({
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.textLight,
                      size: 40,
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
