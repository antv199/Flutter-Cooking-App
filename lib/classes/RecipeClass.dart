import 'package:hive/hive.dart';

part 'RecipeClass.g.dart'; // Required for Hive type adapter generation

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  String title; // Removed final

  @HiveField(1)
  String description; // Removed final

  @HiveField(2)
  int preparationTime; // Removed final

  @HiveField(3)
  int difficulty; // Removed final

  @HiveField(4)
  String imageUrl; // Removed final

  @HiveField(5)
  int rating;

  Recipe({
    required this.title,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.imageUrl,
    this.rating = 0,
  });
}
