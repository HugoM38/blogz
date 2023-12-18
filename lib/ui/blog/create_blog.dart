import 'package:blogz/database/blog/blog.dart';
import 'package:blogz/database/blog/blog_query.dart';
import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/ui/shared/blogz_button.dart';
import 'package:blogz/ui/shared/blogz_error_snackbar.dart';
import 'package:blogz/ui/shared/blogz_image_picker.dart';
import 'package:blogz/ui/shared/blogz_succes_snackbar.dart';
import 'package:blogz/utils/build_text_form_field.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:blogz/utils/upload_image.dart';
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
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  Uint8List? _imageBytes;
  String? _imageExtension;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: const BlogzAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Créer mon blogz',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextFormField(
                          context, _titleController, 'Titre', Icons.title),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextFormField(context, _summaryController,
                          'Sommaires', Icons.description),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextFormField(context, _contentController,
                          'Contenu', Icons.text_fields,
                          maxLines: 5),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextFormField(
                          context, _tagsController, 'Tags', Icons.tag),
                    ),
                    BlogzImagePicker(
                      pickImage: _pickImage,
                      imageBytes: _imageBytes,
                      size: MediaQuery.of(context).size.width * 0.15,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                      child: BlogzButton(
                        key: const Key('CreateBlog'),
                        onPressed: _createBlog,
                        text: 'Soumettre',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createBlog() async {
    String? imageUrl;
    final String uuid = const Uuid().v4();
    if (_imageBytes != null) {
      imageUrl = await uploadImage(_imageBytes!, uuid, _imageExtension)
          .catchError((error) {
        BlogzErrorSnackbar(context).showSnackBar(error.toString());
        return null;
      });
    } else {
      if (mounted) {
        BlogzErrorSnackbar(context)
            .showSnackBar("Vous n'avez mis aucune image");
      }
      return;
    }

    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _summaryController.text.isEmpty) {
      if (mounted) {
        BlogzErrorSnackbar(context).showSnackBar(
            'Veuillez saisir au moins un titre, un résumé et le contenu du blogz');
      }
      return;
    }

    final List<String>? tags = _tagsController.text.isNotEmpty
        ? _tagsController.text.split(',')
        : null;

    final Blog blog = Blog(
        uuid: uuid,
        title: _titleController.text,
        author: SharedPrefs().getCurrentUser()!,
        summary: _summaryController.text,
        imageUrl: imageUrl,
        content: _contentController.text,
        publishedDate: DateTime.now(),
        tags: tags,
        likes: []);

    BlogQuery().addBlog(blog).then((_) {
      if (mounted) {
        BlogzSuccessSnackbar(context)
            .showSnackBar('Le Blogz a été ajouté avec succés');
      }
      Navigator.pop(context, blog);
    }).catchError((error) {
      if (mounted) {
        BlogzErrorSnackbar(context).showSnackBar(error);
      }
    });
  }

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
      if (mounted) {
        BlogzErrorSnackbar(context)
            .showSnackBar("Erreur lors de la sélection de l'image");
      }
    }
  }
}
