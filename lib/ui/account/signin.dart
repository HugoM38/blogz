import 'package:blogz/database/users/user_query.dart';
import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/ui/shared/blogz_button.dart';
import 'package:blogz/ui/shared/blogz_error_snackbar.dart';
import 'package:blogz/utils/build_text_form_field.dart';
import 'package:blogz/utils/hash_password.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            height: MediaQuery.of(context).size.height * 0.50,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Connexion",
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
                              "Nom d'utilisateur",
                              Icons.person,
                              fieldType: FieldType.text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: buildTextFormField(
                              context,
                              _passwordController,
                              "Mot de passe",
                              Icons.password,
                              fieldType: FieldType.password),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: BlogzButton(
                              onPressed: signin,
                              text: "Se connecter",
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: BlogzButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/signup");
                              },
                              text: "S'inscrire",
                            ),
                          ),
                        ],
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

  void signin() {
    String username = _usernameController.text;
    String password = hashPassword(_passwordController.text);

    UserQuery().signin(username, password).then((user) async {
      await SharedPrefs().setCurrentUser(user.username);
      if (user.imageUrl != null) {
        await SharedPrefs().setCurrentImage(user.imageUrl!);
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    }).catchError((error) {
      BlogzErrorSnackbar(context).showSnackBar(error.toString());
    });
  }
}
