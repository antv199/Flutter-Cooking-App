import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../classes/RecipeClass.dart'; // Import the Recipe class
import '../RecipePage/RecipePage.dart'; // <-- Correct import
import '../../EditRecipePage.dart'; // Import the EditRecipePage

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
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Navigate to EditRecipePage
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditRecipePage(recipe: recipe, index: 0),
            ),
          );
          return false; // Prevent the card from being dismissed
        } else if (direction == DismissDirection.endToStart) {
          // Confirm deletion
          final shouldDelete =
              await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Recipe'),
                      content: const Text(
                        'Are you sure you want to delete this recipe?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              ) ??
              false;

          if (shouldDelete) {
            onDelete();
            return true; // Allow the card to be dismissed
          }
          return false; // Prevent the card from being dismissed
        }
        return false;
      },
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0),
        child: const Text(
          'Edit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Text(
          'Delete',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
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
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < recipe.difficulty ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  );
                }),
              ),
              Text('Difficulty: ${recipe.difficulty}/5'),
            ],
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe),
              ),
            );
            onDelete(); // Trigger a refresh by removing and re-adding the recipe
          },
        ),
      ),
    );
  }
}
