import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'classes/RecipeClass.dart'; // Import the Recipe class
import 'widgets/Home/RecipeHomeCard.dart'; // Import the RecipeHomeCard widget
import 'CreateRecipePage.dart'; // Import the CreateRecipePage class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter()); // Register the Recipe adapter
  await Hive.openBox<Recipe>('recipes'); // Open the Hive box for recipes
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    final recipeBox = Hive.box<Recipe>('recipes');
    recipes = recipeBox.values.toList();
  }

  void updateRating(int index, int newRating) {
    setState(() {
      recipes[index].rating = newRating;
    });
  }

  void sortRecipes(String criteria) {
    setState(() {
      if (criteria == 'difficulty') {
        recipes.sort((a, b) => a.difficulty.compareTo(b.difficulty));
      } else if (criteria == 'rating') {
        recipes.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (criteria == 'preparationTime') {
        recipes.sort((a, b) => a.preparationTime.compareTo(b.preparationTime));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooking Recipes'),
        actions: [
          PopupMenuButton<String>(
            onSelected: sortRecipes,
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'difficulty',
                    child: Text('Sort by Difficulty'),
                  ),
                  const PopupMenuItem(
                    value: 'rating',
                    child: Text('Sort by Rating'),
                  ),
                  const PopupMenuItem(
                    value: 'preparationTime',
                    child: Text('Sort by Preparation Time'),
                  ),
                ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeHomeCard(
            recipe: recipe,
            onDelete: () {
              setState(() {
                recipes.removeAt(index);
              });
            },
            onTap: () {
              // Navigate to recipe details screen
            },
            onRatingChanged: (newRating) {
              updateRating(index, newRating);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRecipePage()),
          ).then((_) {
            setState(() {}); // Refresh the home screen after returning
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
