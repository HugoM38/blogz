import 'package:blogz/database/database.dart';
import 'package:blogz/database/blog/blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogQuery {
  CollectionReference blogsCollection =
      Database().firestore.collection('Blogs');

  Future<void> addBlog(Blog blog) async {
    await blogsCollection.add(blog.toMap());
  }
  
  Future<List<Blog>> getBlogs() async {
    QuerySnapshot query = await blogsCollection.get();
    return query.docs
        .map((doc) => Blog.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
