import 'package:blogz/firebase_options.dart';
import 'package:blogz/ui/account/signin.dart';
import 'package:blogz/ui/account/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Blogz());
}

class Blogz extends StatelessWidget {
  const Blogz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blogz',
      initialRoute: '/', // Route initiale
      routes: {
        '/': (context) => const MainPage(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const SignInPage()
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const SignInPage();
  }
}
