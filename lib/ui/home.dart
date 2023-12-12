import 'package:blogz/ui/blog/create_blog.dart';
import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlogzAppBar(),
      body: const Center(
        child: Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBlogPage()),
          );
        },
        child: const Icon(Icons.add), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}