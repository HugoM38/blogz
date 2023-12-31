import 'package:blogz/database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment.dart';

class CommentQuery {
  final CollectionReference _commentsCollection =
      Database().firestore.collection('Comments');

  Future<void> addComment(Comment comment) async {
    await _commentsCollection.add(comment.toMap()).catchError((error) {
      throw Exception("Impossible d'ajouter le commentaire");
    });
  }

  Future<List<Comment>> getCommentsFromBlog(String uuid) async {
    final QuerySnapshot query = await _commentsCollection
        .where('uuid', isEqualTo: uuid)
        .orderBy('date', descending: true)
        .get()
        .catchError((error) {
      throw Exception('Erreur lors de la récupération des commentaires');
    });
    return query.docs
        .map((doc) =>
            Comment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
