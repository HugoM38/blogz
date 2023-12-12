import 'package:blogz/database/users/user.dart';
import 'package:blogz/database/users/user_query.dart';
import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/utils/check_regex.dart';
import 'package:blogz/utils/hash_password.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlogzAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Nom d'utilisateur",
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                if (!checkRegex(_passwordController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Le mot de passe doit contenir au moins 8 caractères, 1 chiffre et 1 majuscule"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                String password = hashPassword(_passwordController.text);

                UserQuery()
                    .signup(User(username: username, password: password))
                    .then((_) async {
                  await SharedPrefs().setCurrentUser(username);
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, "/home");
                  }
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              child: const Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}
