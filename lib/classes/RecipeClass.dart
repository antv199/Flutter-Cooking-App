import 'package:hive/hive.dart';

part 'RecipeClass.g.dart'; // Required for Hive type adapter generation

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int preparationTime;

  @HiveField(3)
  final int difficulty; // Int (1-5)

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  int rating; // Int (1-5)

  Recipe({
    required this.title,
    required this.description,
    required this.preparationTime,
    required this.difficulty,
    required this.imageUrl,
    this.rating = 0,
  });
}
