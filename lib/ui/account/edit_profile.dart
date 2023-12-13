import 'dart:typed_data';

import 'package:blogz/database/users/user_query.dart';
import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/ui/shared/blogz_button.dart';
import 'package:blogz/ui/shared/blogz_error_snackbar.dart';
import 'package:blogz/ui/shared/blogz_image_picker.dart';
import 'package:blogz/ui/shared/blogz_succes_snackbar.dart';
import 'package:blogz/utils/build_text_form_field.dart';
import 'package:blogz/utils/check_regex.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:blogz/utils/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageExtension;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: const BlogzAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: SingleChildScrollView(
              child: Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Modifier mon profil",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BlogzImagePicker(
                            pickImage: _pickImage,
                            imageBytes: _imageBytes,
                            size: MediaQuery.of(context).size.width * 0.10),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.10,
                          child: BlogzButton(
                            onPressed: _changeImageProfile,
                            text: "Modifier",
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Divider(
                            indent: 50.0,
                            endIndent: 50.0,
                            color: Theme.of(context).colorScheme.primary),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: buildTextFormField(
                                context,
                                _usernameController,
                                "Nouveau nom d'utilisateur",
                                Icons.person,
                                fieldType: FieldType.text),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.10,
                          child: BlogzButton(
                            onPressed: _changeUsername,
                            text: "Modifier",
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Divider(
                            indent: 50.0,
                            endIndent: 50.0,
                            color: Theme.of(context).colorScheme.primary),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: buildTextFormField(
                                context,
                                _oldPasswordController,
                                "Ancien mot de passe",
                                Icons.password,
                                fieldType: FieldType.password),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: buildTextFormField(
                                context,
                                _newPasswordController,
                                "Nouveau mot de passe",
                                Icons.password,
                                fieldType: FieldType.password),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: BlogzButton(
                              onPressed: _changePassword,
                              text: "Modifier",
                            ),
                          ),
                        ),
                      ],
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

  void _changeUsername() {
    if (_usernameController.text.isNotEmpty) {
      UserQuery()
          .usernameUpdate(
              SharedPrefs().getCurrentUser()!, _usernameController.text)
          .then((_) {
        BlogzSuccessSnackbar(context)
            .showSnackBar("Nom d'utilisateur modifié avec succès");
        SharedPrefs().setCurrentUser(_usernameController.text);
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (Route<dynamic> route) => false);
      }).catchError((error) {
        BlogzErrorSnackbar(context).showSnackBar(error.toString());
      });
    } else {
      BlogzErrorSnackbar(context)
          .showSnackBar("Veuillez saisir un nom d'utilisateur");
    }
  }

  void _changePassword() {
    if (_newPasswordController.text.isNotEmpty &&
        _oldPasswordController.text.isNotEmpty) {
      if (checkRegex(_newPasswordController.text)) {
        UserQuery()
            .passwordUpdate(SharedPrefs().getCurrentUser()!,
                _oldPasswordController.text, _newPasswordController.text)
            .then((_) {
          BlogzSuccessSnackbar(context)
              .showSnackBar("Mot de passe modifié avec succès");
          Navigator.pushNamedAndRemoveUntil(
              context, "/home", (Route<dynamic> route) => false);
        }).catchError((error) {
          BlogzErrorSnackbar(context).showSnackBar(error.toString());
        });
      } else {
        BlogzErrorSnackbar(context).showSnackBar(
            "Le mot de passe doit contenir au moins 8 caractères, 1 chiffre et 1 majuscule");
      }
    } else {
      BlogzErrorSnackbar(context)
          .showSnackBar("Veuillez saisir l'ancien et le nouveau mot de passe");
    }
  }

  void _changeImageProfile() async {
    String imageUrl;
    if (_imageBytes != null) {
      imageUrl = (await uploadImage(
          _imageBytes!, SharedPrefs().getCurrentUser()!, _imageExtension))!;
    } else {
      BlogzErrorSnackbar(context)
          .showSnackBar("Veuillez selectionner une image");
      return;
    }

    UserQuery().changeImage(imageUrl).then((_) {
      setState(() {
        SharedPrefs().setCurrentImage(imageUrl);
      });
      BlogzSuccessSnackbar(context).showSnackBar("Image modifiée avec succès");
      Navigator.pushNamedAndRemoveUntil(
          context, "/home", (Route<dynamic> route) => false);
    }).catchError((error) {
      BlogzErrorSnackbar(context).showSnackBar(error.toString());
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
    } catch (_) {
      if (context.mounted) {
        BlogzErrorSnackbar(context)
            .showSnackBar("Erreur lors de la sélection de l'image");
      }
    }
  }
}
