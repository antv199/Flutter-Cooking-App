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
  bool _isPickingImage = false; // Add a flag to track the image picker state

  Future<void> _pickImage() async {
    if (_isPickingImage) return; // Prevent multiple calls
    _isPickingImage = true;

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageUrl = pickedFile.path;
        });
      }
    } catch (e) {
      // Handle any errors that occur during image picking
      debugPrint('Error picking image: $e');
    } finally {
      _isPickingImage = false; // Reset the flag
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
      appBar: AppBar(title: const Text('Create Recipe')),
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
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _preparationTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Preparation Time (minutes)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter preparation time';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Difficulty'),
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
                  child: const Text('Pick Image'),
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
                  child: const Text('Save Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _preparationTimeController;
  String? _imageUrl;
  int _difficulty = 1;
  bool _isPickingImage = false; // Add a flag to track the image picker state

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController = TextEditingController(
      text: widget.recipe.description,
    );
    _preparationTimeController = TextEditingController(
      text: widget.recipe.preparationTime.toString(),
    );
    _imageUrl = widget.recipe.imageUrl;
    _difficulty = widget.recipe.difficulty;
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return; // Prevent multiple calls
    _isPickingImage = true;

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageUrl = pickedFile.path;
        });
      }
    } catch (e) {
      // Handle any errors that occur during image picking
      debugPrint('Error picking image: $e');
    } finally {
      _isPickingImage = false; // Reset the flag
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      widget.recipe
        ..title = _titleController.text
        ..description = _descriptionController.text
        ..preparationTime = int.parse(_preparationTimeController.text)
        ..difficulty = _difficulty
        ..imageUrl = _imageUrl ?? '';

      widget.recipe.save(); // Save the updated recipe to Hive

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Recipe')),
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
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _preparationTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Preparation Time (minutes)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter preparation time';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Difficulty'),
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
                  child: const Text('Pick Image'),
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
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
