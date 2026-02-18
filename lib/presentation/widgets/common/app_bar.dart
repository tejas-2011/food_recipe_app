import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class TasteAtlasAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPress;

  const TasteAtlasAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.primary, size: 20),
              onPressed: onBackPress,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
