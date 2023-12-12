import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/ui/shared/blogz_button.dart';
import 'package:blogz/utils/build_text_form_field.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

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
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 16.0),
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
                          onPressed: changeUsername,
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
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: BlogzButton(
                          onPressed: changePassword,
                          text: "Modifier",
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
    );
  }

  void changeUsername() {}
  void changePassword() {}
}
