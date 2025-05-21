import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../classes/RecipeClass.dart';
import '../../EditRecipePage.dart'; // Import the EditRecipePage
import '../common/RecipeImage.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  const RecipePage({super.key, required this.recipe});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.recipe.rating; // Initialize with the saved rating
  }

  void _updateRating(int newRating) {
    setState(() {
      _currentRating = newRating;
      widget.recipe.rating = newRating; // Update the recipe's rating
      widget.recipe.save(); // Save the updated rating to Hive
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecipeImage(
                imageUrl: widget.recipe.imageUrl,
                width: double.infinity,
                height: 200,
              ),
              const SizedBox(height: 16),
              Text(
                widget.recipe.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Difficulty: ${widget.recipe.difficulty}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Preparation Time: ${widget.recipe.preparationTime} minutes',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                widget.recipe.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text('Rating:'),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      _updateRating(index + 1); // Update the rating
                    },
                    child: Icon(
                      index < _currentRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditRecipePage(
                            recipe: widget.recipe,
                            index: widget.recipe.key as int,
                          ),
                    ),
                  ).then((_) {
                    setState(() {}); // Refresh the page after returning
                  });
                },
                child: const Text('Edit Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
