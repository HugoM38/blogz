import 'package:flutter/material.dart';

void main() async {
  runApp(const Blogz());
}

class Blogz extends StatelessWidget {
  const Blogz({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blogz',
      home: MainPage(),
      routes: {},
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
    return Scaffold(
        //On vérifie si l'utilisateur est connecté afin de le rediriger
        body: Container());
  }
}
