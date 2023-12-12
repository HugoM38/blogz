import 'package:blogz/database/database.dart';
import 'package:blogz/database/blog/blog.dart';
import 'package:blogz/database/blog/blog_query.dart';
import 'package:blogz/ui/shared/blogz_image_picker.dart';
import 'package:blogz/utils/build_text_form_field.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

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
  String? _imageExtension;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageExtension = path.extension(pickedFile.path);
        });
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de la sélection de l'image"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      String fileNameWithExtension = fileName + (_imageExtension ?? '.jpg');

      final ref = Database()
          .firebaseStorage
          .ref()
          .child('images/$fileNameWithExtension');

      final result = await ref.putData(imageBytes);

      return await result.ref.getDownloadURL();
    } catch (_) {
      throw Exception("Envoie de l'image impossible");
    }
  }

  void _createBlog() async {
    String? imageUrl;
    final String uuid = const Uuid().v4();
    if (_imageBytes != null) {
      imageUrl = await uploadImage(_imageBytes!, uuid).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous n'avez mis aucune image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez saisir au moins un titre un auteur"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    List<String>? tags = _tagsController.text.isNotEmpty
        ? _tagsController.text.split(',')
        : null;

    DateTime? publishedDate;
    try {
      publishedDate = DateTime.parse(_dateController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Format de date invalide"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Blog newBlog = Blog(
      uuid: uuid,
      title: _titleController.text,
      author: _authorController.text,
      summary: _summaryController.text,
      imageUrl: imageUrl,
      content: _contentController.text,
      publishedDate: publishedDate,
      tags: tags,
    );
    BlogQuery().addBlog(newBlog).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le Blogz a été ajouté avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
      // BookManager().books.add(newBook); Singleton en attente ??
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Blogz'),
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
                BlogzImagePicker(
                    pickImage: _pickImage, imageBytes: _imageBytes),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                  child: ElevatedButton(
                    onPressed: _createBlog,
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
