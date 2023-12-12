import 'package:blogz/firebase_options.dart';
import 'package:blogz/ui/account/signin.dart';
import 'package:blogz/ui/account/signup.dart';
import 'package:blogz/ui/home.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPrefs().initSharedPrefs();

  runApp(const Blogz());
}

class Blogz extends StatelessWidget {
  const Blogz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blogz',
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF392F5A),
            primary: const Color(0xFF392F5A),
            secondary: const Color(0xFFFAFAC6)),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const MainPage(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const SignInPage(),
        '/home': (context) => const HomePage(),
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
    return SharedPrefs().getCurrentUser() == null
        ? const SignInPage()
        : const HomePage();
  }
}
