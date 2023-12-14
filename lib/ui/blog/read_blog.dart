import 'package:blogz/ui/shared/blogz_appbar.dart';
import 'package:blogz/database/comment/comment.dart';
import 'package:blogz/database/comment/comment_query.dart';
import 'package:blogz/database/blog/blog.dart';
import 'package:blogz/database/users/user_query.dart';
import 'package:blogz/ui/shared/blogz_button.dart';
import 'package:blogz/utils/build_text_form_field.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReadBlogPage extends StatefulWidget {
  final Blog blog;

  const ReadBlogPage({super.key, required this.blog});

  @override
  State<ReadBlogPage> createState() => _ReadBlogPageState();
}

class _ReadBlogPageState extends State<ReadBlogPage> {
  List<Comment> comments = [];
  final TextEditingController _textEditingController = TextEditingController();
  String? authorImageUrl;

  @override
  void initState() {
    loadAuthorImage();
    _loadComment();
    super.initState();
  }

  Future<void> _loadComment() async {
    List<Comment> loadedComments =
        await CommentQuery().getCommentFromBlogz(widget.blog.uuid);
    setState(() {
      comments = loadedComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: const BlogzAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              widget.blog.title,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                widget.blog.imageUrl!,
                                width: MediaQuery.of(context).size.width * 0.5,
                                fit: BoxFit.cover,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                      child: authorImageUrl != null
                                          ? Image.network(
                                              authorImageUrl!,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.blog.author,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(widget.blog.publishedDate),
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            widget.blog.content,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: buildTextFormField(
                                    context,
                                    _textEditingController,
                                    "Écrire un commentaire",
                                    Icons.comment,
                                    fieldType: FieldType.text,
                                    maxLines: 2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlogzButton(
                                  onPressed: newComment, text: 'Envoyer'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return buildRowTemplate(
                                    comments[index], Key(index.toString()));
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future newComment() async {
    var comment = Comment(
        content: _textEditingController.text,
        author: SharedPrefs().getCurrentUser()!,
        uuid: widget.blog.uuid,
        date: DateTime.now());
    await CommentQuery().addComment(comment);
  }

  Future loadAuthorImage() async {
    authorImageUrl = await UserQuery().getImageByUsername(widget.blog.author);
  }

  Widget buildRowTemplate(Comment comment, Key key) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              key: key,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        comment.author,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        comment.content,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Text(
                          DateFormat("dd/MM/yyyy HH:mm").format(comment.date),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ))),
              ],
            )));
  }
}
