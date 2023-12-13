import 'package:blogz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment.dart';

class CommentQuery {
  CollectionReference commentCollection =
  Database().firestore.collection('Comment');

  Future<void> addComment(Comment comment) async {
    await commentCollection.add(comment.toMap());
  }

  Future<List<Comment>> getCommentFromBlogz(String uuid) async {
    QuerySnapshot query = await commentCollection.where('uuid', isEqualTo: uuid).get();
    return query.docs
        .map((doc) => Comment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}