import 'package:blogz/database/database.dart';
import 'package:blogz/database/users/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserQuery {
  CollectionReference usersCollection =
      Database().firestore.collection('Users');

  Future<void> signup(User user) async {
    QuerySnapshot query =
        await usersCollection.where('username', isEqualTo: user.username).get();
    if (query.docs.isEmpty) {
      usersCollection.add(user.toMap());
    } else {
      throw Exception("Il existe déjà un utilisateur avec ce nom");
    }
  }

  Future<User> signin(String username, String password) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();
    if (query.docs.isNotEmpty) {
      Map<String, dynamic> user =
          query.docs.first.data() as Map<String, dynamic>;
      return User.fromMap(user);
    } else {
      throw Exception("Nom d'utilisateur ou mot de passe incorrect");
    }
  }
}
