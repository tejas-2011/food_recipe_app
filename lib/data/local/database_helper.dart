import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'label TEXT UNIQUE, '
          'imageUrl TEXT, '
          'url TEXT, '
          'calories REAL'
          ')',
        );
      },
    );
  }

  Future<void> insertFavorite(RecipeModel recipe) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'label': recipe.label,
        'imageUrl': recipe.imageUrl,
        'url': recipe.url,
        'calories': recipe.calories,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteFavorite(String label) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'label = ?',
      whereArgs: [label],
    );
  }

  Future<List<RecipeModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return RecipeModel(
        label: maps[i]['label'] as String? ?? 'Favorite',
        imageUrl: maps[i]['imageUrl'] as String? ?? '',
        url: maps[i]['url'] as String? ?? '',
        calories: (maps[i]['calories'] as num?)?.toDouble() ?? 0.0,
        ingredientLines: [],
        totalNutrients: {},
      );
    });
  }
}
