import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'classes/RecipeClass.dart';
import 'dart:io';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;
  final int index;

  const EditRecipePage({super.key, required this.recipe, required this.index});

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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedRecipe = Recipe(
        title: _titleController.text,
        description: _descriptionController.text,
        preparationTime: int.parse(_preparationTimeController.text),
        difficulty: _difficulty,
        imageUrl: _imageUrl!,
      );

      final box = Hive.box<Recipe>('recipes');
      if (widget.index >= 0 && widget.index < box.length) {
        box.putAt(widget.index, updatedRecipe);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Επεξεργασία Συνταγής')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child:
                        _imageUrl == null
                            ? const Center(child: Text('Προσθήκη εικόνας'))
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_imageUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Τίτλος',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Συμπληρώστε τον τίτλο' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Περιγραφή',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Συμπληρώστε την περιγραφή' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preparationTimeController,
                decoration: const InputDecoration(
                  labelText: 'Χρόνος προετοιμασίας',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Συμπληρώστε το χρόνο' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _difficulty,
                items:
                    List.generate(5, (index) => index + 1)
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text('Δυσκολία $level'),
                          ),
                        )
                        .toList(),
                decoration: const InputDecoration(
                  labelText: 'Δυσκολία',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _difficulty = value!),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Αποθήκευση Αλλαγών'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
