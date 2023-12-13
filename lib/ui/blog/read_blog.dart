import 'package:blogz/database/Comment/comment.dart';
import 'package:blogz/database/Comment/comment_query.dart';
import 'package:blogz/database/blog/blog.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class ReadBlogPage extends StatefulWidget {
  Blog blog;
  ReadBlogPage({super.key, required this.blog});

  @override
  State<ReadBlogPage> createState() => _ReadBlogPageState();
}

class _ReadBlogPageState extends State<ReadBlogPage> {
  @override
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zone de texte et bouton ${widget.blog.uuid}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Entrez du texte...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var comment = Comment(
                    content: _textEditingController.text,
                    author: SharedPrefs().getCurrentUser()!,
                    uuid: widget.blog.uuid,
                    date: DateTime.now());
                CommentQuery().addComment(comment);
              },
              child: const Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}
