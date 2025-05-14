class Recipe {
  final String title;
  final String description;
  final int preparationTime;
  final String difficulty;
  final String imageUrl;
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