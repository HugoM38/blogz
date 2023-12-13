import 'package:blogz/database/blog/blog_query.dart';
import 'package:blogz/ui/blog/create_blog.dart';
import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/ui/shared/blogz_button.dart';
import 'package:flutter/material.dart';

import '../database/blog/blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isBlogsLoaded = false;
  List<Blog> blogs = [];
  List<Blog> filteredBlogs = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!isBlogsLoaded) {
      try {
        List<Blog> loadedBlogs = await BlogQuery().getBlogs();
        setState(() {
          blogs = loadedBlogs;
          filteredBlogs = loadedBlogs;
          isBlogsLoaded = true;
        });
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlogzAppBar(actions: getAppBarActions()),
      ),
      body: blogs.isEmpty
          ? Center(
              child: Text(
              'Aucun blog disponible.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(blogs[index].title!),
                      subtitle: Text(blogs[index].summary!),
                      leading: const Icon(Icons.credit_card),
                      onTap: () {
                        // Action à effectuer lorsque la carte est cliquée
                        Navigator.pushNamed(context, "/blog", arguments: blogs[index].uuid );
                      },
                    ),
                  );
                }
              }),
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

  List<Widget> getAppBarActions() {
    return [
      BlogzButton(
          text: "Modifier mon profil",
          onPressed: () async {
            Navigator.pushNamed(context, "/edit-profile");
          })
    ];
  }
}
