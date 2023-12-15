import 'package:blogz/database/database.dart';
import 'package:blogz/database/blog/blog.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogQuery {
  CollectionReference blogsCollection =
      Database().firestore.collection('Blogs');

  Future<void> addBlog(Blog blog) async {
    await blogsCollection.add(blog.toMap()).catchError((error) {
      throw Exception("Impossible de créer le blogz");
    });
  }

  Future<List<Blog>> getBlogs() async {
    QuerySnapshot query = await blogsCollection.get();
    return query.docs
        .map((doc) => Blog.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future addLike(Blog blog) async {
    QuerySnapshot query = await blogsCollection
        .where('uuid', isEqualTo: blog.uuid)
        .get()
        .catchError((error) {
      throw Exception("Une erreur est survenue lors du like");
    });
    if (query.docs.isNotEmpty) {
      Blog updateBlog =
          Blog.fromMap(query.docs.first.data() as Map<String, dynamic>);
      updateBlog.likes.add(SharedPrefs().getCurrentUser()!);
      await blogsCollection
          .doc(query.docs.first.id)
          .update({'likes': updateBlog.likes}).catchError((error) {
        throw Exception("Une erreur est survenue lors du like");
      });
    } else {
      throw Exception("Une erreur est survenue lors du like");
    }
  }

  Future removeLike(Blog blog) async {
    QuerySnapshot query = await blogsCollection
        .where('uuid', isEqualTo: blog.uuid)
        .get()
        .catchError((error) {
      throw Exception("Une erreur est survenue lors du like");
    });
    if (query.docs.isNotEmpty) {
      Blog updateBlog =
          Blog.fromMap(query.docs.first.data() as Map<String, dynamic>);
      updateBlog.likes.remove(SharedPrefs().getCurrentUser()!);
      await blogsCollection
          .doc(query.docs.first.id)
          .update({'likes': updateBlog.likes}).catchError((error) {
        throw Exception("Une erreur est survenue lors du like");
      });
    } else {
      throw Exception("Une erreur est survenue lors du like");
    }
  }
}
