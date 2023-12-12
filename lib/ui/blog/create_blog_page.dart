import 'package:blogz/utils/build_text_form_field.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Blog'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTextFormField(
                    context, _titleController, 'Titre', Icons.title),
                buildTextFormField(context, _dateController, 'Date de création',
                    Icons.calendar_today,
                    fieldType: FieldType.date, initialDate: DateTime.now()),
                buildTextFormField(context, _summaryController, 'Sommaires',
                    Icons.description),
                buildTextFormField(
                    context, _contentController, 'Contenu', Icons.text_fields,
                    maxLines: 5),
                buildTextFormField(context, _tagsController, 'Tags', Icons.tag),
                buildTextFormField(
                    context, _authorController, 'Auteur', Icons.person),
                GestureDetector(
                  onTap: _pickImage,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _imageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.add_a_photo, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour soumettre le formulaire
                    },
                    child: const Text('Soumettre'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
