import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../resources/constants/strings.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    required this.onSearch,
    this.onFilterTap,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: AppConstants.searchHintText,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  widget.onSearch(value.trim());
                }
              },
            ),
          ),
          if (widget.onFilterTap != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: widget.onFilterTap,
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}