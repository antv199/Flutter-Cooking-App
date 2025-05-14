import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../classes/RecipeClass.dart'; // Import the Recipe class
import '../RecipePage/RecipePage.dart'; // Import the RecipePage

class RecipeHomeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final ValueChanged<int> onRatingChanged; // Callback for rating change

  const RecipeHomeCard({
    super.key,
    required this.recipe,
    required this.onDelete,
    required this.onTap,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(recipe.title),
      onDismissed: (direction) {
        onDelete();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${recipe.title} deleted')));
      },
      background: Container(color: Colors.red),
      child: Card(
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: recipe.imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget:
                (context, url, error) => const Icon(Icons.broken_image),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(recipe.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Difficulty: ${recipe.difficulty}'),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      onRatingChanged(index + 1); // Update rating
                    },
                    child: Icon(
                      index < recipe.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe),
              ),
            );
          },
        ),
      ),
    );
  }
}
