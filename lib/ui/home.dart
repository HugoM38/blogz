import 'package:blogz/database/blog/blog_query.dart';
import 'package:blogz/ui/blog/create_blog.dart';
import 'package:blogz/ui/blog/read_blog.dart';
import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/ui/shared/blogz_button.dart';
import 'package:blogz/ui/shared/blogz_error_snackbar.dart';
import 'package:blogz/ui/shared/blogz_searchbar.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

import '../database/blog/blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBlogsLoaded = false;
  List<Blog> _blogs = [];
  List<Blog> _filteredBlogs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBlogz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: BlogzAppBar(
        actions: getAppBarActions(),
        displayLogo: true,
      ),
      body: _blogs.isEmpty
          ? Center(
              child: Text(
              'Aucun blog disponible.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ))
          : Padding(
              padding: const EdgeInsets.fromLTRB(48, 24, 48, 24),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 3 / 3.5,
                  ),
                  itemCount: _filteredBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = _filteredBlogs[index];
                    return InkWell(
                      onTap: () {
                        _goToBlog(blog);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(blog.imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                blog.title,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                blog.summary,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 12),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateBlog,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Widget> getAppBarActions() {
    final String? imageUrl = SharedPrefs().getCurrentImage();
    return [
      Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          child: BlogzSearchBar(
            hintText: 'Rechercher un blogz',
            searchController: _searchController,
            onSearchChanged: _filterBlogz,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlogzButton(text: 'Se déconnecter', onPressed: _logout),
      ),
      imageUrl != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: _goToProfile,
                  child: ClipOval(
                      child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ))),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: _goToProfile, icon: const Icon(Icons.person)),
            ),
    ];
  }

  void _filterBlogz(String searchText) {
    final searchLower = searchText.toLowerCase();
    setState(() {
      _filteredBlogs = _blogs.where((blog) {
        return blog.title.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  void _goToBlog(Blog blog) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReadBlogPage(blog: blog)));
  }

  Future<void> _goToCreateBlog() async {
    final Blog? blog = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateBlogPage()),
    );

    setState(() {
      if (blog != null) {
        _blogs.add(blog);
        _loadBlogz();
      }
    });
  }

  Future<void> _goToProfile() async {
    await Navigator.pushNamed(context, '/edit-profile');
    setState(() {}); // Reload page to display image
  }

  Future<void> _loadBlogz() async {
    if (!_isBlogsLoaded) {
      try {
        final List<Blog> loadedBlogs = await BlogQuery().getBlogs();
        setState(() {
          _blogs = loadedBlogs;
          _filteredBlogs = loadedBlogs;
          _isBlogsLoaded = true;
        });
      } catch (error) {
        if (context.mounted) {
          BlogzErrorSnackbar(context).showSnackBar(error.toString());
        }
      }
    }
    setState(() {
      _filteredBlogs = _blogs;
    });
  }

  Future<void> _logout() async {
    await SharedPrefs().removeCurrentImage();
    await SharedPrefs().removeCurrentUser();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
