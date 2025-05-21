import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'classes/RecipeClass.dart';
import 'widgets/Home/RecipeHomeCard.dart';
import 'CreateRecipePage.dart';
import 'RecipePage.dart' as RecipePageAlias;
import 'widgets/RecipePage/RecipePage.dart';

late Box<Recipe> recipeBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  recipeBox = await Hive.openBox<Recipe>('recipes');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: RecipeHomePage(
        onToggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class RecipeHomePage extends StatefulWidget {
  final void Function(bool) onToggleTheme;
  final bool isDarkMode;

  const RecipeHomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Οι Συνταγές Μου'),
        centerTitle: true,
        actions: [
          Switch(value: widget.isDarkMode, onChanged: widget.onToggleTheme),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: recipeBox.listenable(),
        builder: (context, Box<Recipe> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('Δεν υπάρχουν συνταγές ακόμα.'));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ), // Adjust as needed
            child: ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final recipe = box.getAt(index);
                return RecipeHomeCard(
                  recipe: recipe!,
                  index: index, // <-- pass this index
                  onDelete: () {
                    setState(() {
                      recipeBox.deleteAt(index);
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipePage(recipe: recipe),
                      ),
                    );
                  },
                  onRatingChanged: (int rating) {
                    setState(() {
                      recipe.rating = rating;
                      recipe.save();
                    });
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRecipePage()),
          );
        },
        label: const Text('Νέα Συνταγή'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
