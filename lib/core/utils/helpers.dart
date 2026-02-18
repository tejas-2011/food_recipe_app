import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Helper utilities for common operations
class Helpers {
  Helpers._();

  // ============= FORMATTING =============

  /// Format calories to string with unit
  static String formatCalories(double calories) {
    return '${calories.toStringAsFixed(0)} kcal';
  }

  /// Format weight in grams
  static String formatGrams(double grams) {
    if (grams >= 1000) {
      return '${(grams / 1000).toStringAsFixed(1)} kg';
    }
    return '${grams.toStringAsFixed(1)} g';
  }

  /// Format time in minutes
  static String formatTime(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '$hours hr';
      }
      return '$hours hr $mins min';
    }
    return '$minutes min';
  }

  /// Format rating (1-5 scale)
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Format servings
  static String formatServings(int servings) {
    return servings == 1 ? '1 serving' : '$servings servings';
  }

  // ============= VALIDATION =============

  /// Validate if string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validate if email is valid
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  // ============= DIALOGS & SNACKBARS =============

  /// Show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show info snackbar
  static void showInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(message),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ============= DATE & TIME =============

  /// Get current timestamp
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  // ============= STRING MANIPULATION =============

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Truncate string with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Convert list to comma-separated string
  static String listToString(List<String> items, {int maxItems = 3}) {
    if (items.isEmpty) return '';
    if (items.length <= maxItems) {
      return items.join(', ');
    }
    final displayed = items.take(maxItems).join(', ');
    final remaining = items.length - maxItems;
    return '$displayed +$remaining more';
  }

  // ============= COLORS =============

  /// Get difficulty color
  static Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Get dietary badge color
  static Color getDietaryBadgeColor(String dietary) {
    switch (dietary.toLowerCase()) {
      case 'vegetarian':
        return Colors.green;
      case 'vegan':
        return Colors.teal;
      case 'gluten-free':
        return Colors.orange;
      case 'dairy-free':
        return Colors.purple;
      case 'keto':
        return Colors.red;
      case 'paleo':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  // ============= DEVICE INFO =============

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // ============= HAPTIC FEEDBACK =============

  /// Light haptic feedback
  static void lightHaptic() {
    // HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback
  static void mediumHaptic() {
    // HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback
  static void heavyHaptic() {
    // HapticFeedback.heavyImpact();
  }
}