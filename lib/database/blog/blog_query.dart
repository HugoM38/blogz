import 'package:blogz/database/database.dart';
import 'package:blogz/database/blog/blog.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogQuery {
  final CollectionReference _blogsCollection =
      Database().firestore.collection('Blogs');

  Future<void> addBlog(Blog blog) async {
    await _blogsCollection.add(blog.toMap()).catchError((error) {
      throw Exception('Impossible de créer le blogz');
    });
  }

  Future<List<Blog>> getBlogs() async {
    final QuerySnapshot query =
        await _blogsCollection.get().catchError((error) {
      throw Exception('Erreur lors de la récupération des blogs');
    });
    return query.docs
        .map((doc) => Blog.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future addLike(Blog blog) async {
    final QuerySnapshot query = await _blogsCollection
        .where('uuid', isEqualTo: blog.uuid)
        .get()
        .catchError((error) {
      throw Exception('Une erreur est survenue lors du like');
    });
    if (query.docs.isNotEmpty) {
      final Blog updateBlog =
          Blog.fromMap(query.docs.first.data() as Map<String, dynamic>);
      updateBlog.likes.add(SharedPrefs().getCurrentUser()!);
      await _blogsCollection
          .doc(query.docs.first.id)
          .update({'likes': updateBlog.likes}).catchError((error) {
        throw Exception('Une erreur est survenue lors du like');
      });
    } else {
      throw Exception('Une erreur est survenue lors du like');
    }
  }

  Future removeLike(Blog blog) async {
    final QuerySnapshot query = await _blogsCollection
        .where('uuid', isEqualTo: blog.uuid)
        .get()
        .catchError((error) {
      throw Exception('Une erreur est survenue lors du like');
    });
    if (query.docs.isNotEmpty) {
      final Blog updateBlog =
          Blog.fromMap(query.docs.first.data() as Map<String, dynamic>);
      updateBlog.likes.remove(SharedPrefs().getCurrentUser()!);
      await _blogsCollection
          .doc(query.docs.first.id)
          .update({'likes': updateBlog.likes}).catchError((error) {
        throw Exception('Une erreur est survenue lors du like');
      });
    } else {
      throw Exception('Une erreur est survenue lors du like');
    }
  }
}
