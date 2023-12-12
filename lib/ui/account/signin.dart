import 'package:blogz/database/users/user_query.dart';
import 'package:blogz/utils/hash_password.dart';
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    String password = hashPassword(_passwordController.text);

                    UserQuery().signin(username, password).then((user) {
                      print("Connecté en temps que ${user.username}");
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  },
                  child: const Text('Se connecter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signup");
                  },
                  child: const Text("S'inscrire"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
