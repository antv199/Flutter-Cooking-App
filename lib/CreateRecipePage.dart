import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'classes/RecipeClass.dart';
import 'dart:io';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  String? _imageUrl;
  int _difficulty = 1; // Default difficulty level

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final newRecipe = Recipe(
        title: _titleController.text,
        description: _descriptionController.text,
        preparationTime: int.parse(_preparationTimeController.text),
        difficulty: _difficulty,
        imageUrl: _imageUrl ?? '',
      );

      final recipeBox = Hive.box<Recipe>('recipes');
      recipeBox.add(newRecipe);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Δημιουργία Συνταγής')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Τίτλος'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Παρακαλώ εισάγετε τίτλο';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Περιγραφή'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Παρακαλώ εισάγετε περιγραφή';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _preparationTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Χρόνος Προετοιμασίας (λεπτά)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Παρακαλώ εισάγετε χρόνο προετοιμασίας';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Παρακαλώ εισάγετε έγκυρο αριθμό';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Δυσκολία'),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _difficulty = index + 1; // Update difficulty
                        });
                      },
                      child: Icon(
                        index < _difficulty ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Επιλέξτε Εικόνα'),
                ),
                if (_imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.file(
                      File(_imageUrl!),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: const Text('Αποθήκευση Συνταγής'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
