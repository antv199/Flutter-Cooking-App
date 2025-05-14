import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../classes/RecipeClass.dart';
import '../../EditRecipePage.dart'; // Import the EditRecipePage

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  const RecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl:
                    recipe.imageUrl.isNotEmpty
                        ? recipe.imageUrl
                        : 'https://via.placeholder.com/150', // Fallback URL
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                recipe.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Difficulty: ${recipe.difficulty}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Preparation Time: ${recipe.preparationTime} minutes',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(recipe.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < recipe.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  );
                }),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRecipePage(recipe: recipe),
                    ),
                  );
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
