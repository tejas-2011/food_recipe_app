class AppConstants {
  AppConstants._();

  // App identity
  static const String appName    = 'TasteAtlas';
  static const String appTagline = 'Discover recipes from your ingredients';

  // Splash screen
  static const String splashLoading = 'Loading delicious recipes...';
  static const Duration splashDuration = Duration(seconds: 3);

  // Search
  static const String searchHintText =
      'Search ingredients or recipes...';

  // Recipe display
  static const String calorieUnit   = 'kcal';
  static const String startCooking  =
      'Search for ingredients above\nor take a photo to get started!';
  static const String noFavorites   =
      'No favourites yet.\nTap ❤️ on any recipe to save it.';

  // Dietary filter labels
  static const String vegetarian = 'Vegetarian';
  static const String vegan      = 'Vegan';
  static const String glutenFree = 'Gluten-Free';
  static const String keto       = 'Keto';
  static const String paleo      = 'Paleo';

  // Edamam API header key — kept here for legacy service.dart usage
  static const String usedAccount = 'Edamam-Account-User';
}