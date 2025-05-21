import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../classes/RecipeClass.dart'; // Import the Recipe class
import '../RecipePage/RecipePage.dart'; // <-- Correct import
import '../../EditRecipePage.dart'; // Import the EditRecipePage
import '../../widgets/common/RecipeImage.dart';

class RecipeHomeCard extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final ValueChanged<int> onRatingChanged; // Callback for rating change
  final ValueChanged<int> onDifficultyChanged; // Add this

  const RecipeHomeCard({
    super.key,
    required this.recipe,
    required this.index,
    required this.onDelete,
    required this.onTap,
    required this.onRatingChanged,
    required this.onDifficultyChanged, // Add this
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
              builder:
                  (context) => EditRecipePage(recipe: recipe, recipeKey: index),
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
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ), // Make card a bit taller
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 14,
          ), // More space
          leading: RecipeImage(
            imageUrl: recipe.imageUrl,
            width: 50,
            height: 50,
          ),
          title: Text(recipe.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Βαθμολογία: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...List.generate(5, (starIndex) {
                    return GestureDetector(
                      onTap: () => onRatingChanged(starIndex + 1),
                      child: Icon(
                        starIndex < recipe.rating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 24,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Δυσκολία: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...List.generate(5, (starIndex) {
                    return GestureDetector(
                      onTap: () => onDifficultyChanged(starIndex + 1),
                      child: Icon(
                        starIndex < recipe.difficulty
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.blueGrey,
                        size: 24,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class RecipeHome extends StatefulWidget {
  @override
  _RecipeHomeState createState() => _RecipeHomeState();
}

class _RecipeHomeState extends State<RecipeHome> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeHomeCard(
          recipe: recipe,
          index: index,
          onDelete: () {
            setState(() {
              recipes.removeAt(index);
            });
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe),
              ),
            );
          },
          onRatingChanged: (int rating) {
            setState(() {
              recipe.rating = rating;
              recipe.save();
            });
          },
          onDifficultyChanged: (int difficulty) {
            setState(() {
              recipe.difficulty = difficulty;
              recipe.save();
            });
          },
        );
      },
    );
  }
}
