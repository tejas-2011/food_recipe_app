class RecipeModel {
  final String label;
  final String imageUrl;
  final double calories;
  final List<String> ingredientLines;
  final Map<String, dynamic> totalNutrients;
  final String url;
  final String? difficulty;
  final int? totalTime;
  final int? yield;

  RecipeModel({
    required this.label,
    required this.imageUrl,
    required this.calories,
    required this.ingredientLines,
    required this.totalNutrients,
    required this.url,
    this.difficulty,
    this.totalTime,
    this.yield,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> recipe) {
    return RecipeModel(
      label: recipe["label"] ?? "Unknown Recipe",
      imageUrl: recipe["image"] ?? "",
      calories: (recipe["calories"] as num?)?.toDouble() ?? 0.0,
      ingredientLines: List<String>.from(recipe["ingredientLines"] ?? []),
      totalNutrients: recipe["totalNutrients"] ?? {},
      url: recipe["url"] ?? "",
      difficulty: recipe["difficulty"] as String?,
      totalTime: (recipe["totalTime"] as num?)?.toInt(),
      yield: (recipe["yield"] as num?)?.toInt(),
    );
  }
}