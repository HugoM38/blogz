import 'package:blogz/database/database.dart';
import 'package:blogz/database/users/user.dart';
import 'package:blogz/utils/hash_password.dart';
import 'package:blogz/utils/shared_prefs.dart';
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

  Future<void> changeImage(String imageUrl) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: SharedPrefs().getCurrentUser())
        .get()
        .catchError((error) {
      throw Exception("Erreur lors du changement d'image");
    });
    if (query.docs.isNotEmpty) {
      usersCollection
          .doc(query.docs.first.id)
          .update({'imageUrl': imageUrl}).catchError((error) {
        throw Exception("Une erreur est survenue lors du changement de rôle");
      });
    } else {
      throw Exception("Erreur lors du changement d'image");
    }
  }

  Future<void> passwordUpdate(
      String username, String oldPassword, String newPassword) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: hashPassword(oldPassword))
        .get()
        .catchError((error) {
      throw Exception(
          "Une erreur est survenue lors du changement de mot de passe");
    });
    if (query.docs.isNotEmpty) {
      usersCollection
          .doc(query.docs.first.id)
          .update({'password': hashPassword(newPassword)}).catchError((error) {
        throw Exception(
            "Une erreur est survenue lors du changement de mot de passe");
      });
    } else {
      throw Exception(
          "Une erreur est survenue lors du changement de mot de passe");
    }
  }

  Future<void> usernameUpdate(String username, String newUsername) async {
    QuerySnapshot query = await usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw Exception(
          "Une erreur est survenue lors du changement de nom d'utilisateur");
    });

    QuerySnapshot queryNewUsername = await usersCollection
        .where('username', isEqualTo: newUsername)
        .get()
        .catchError((error) {
      throw Exception(
          "Une erreur est survenue lors du changement de nom d'utilisateur");
    });
    if (query.docs.isNotEmpty && queryNewUsername.docs.isEmpty) {
      await usersCollection
          .doc(query.docs.first.id)
          .update({'username': newUsername}).catchError((error) {
        throw Exception(
            "Une erreur est survenue lors du changement de nom d'utilisateur");
      });
    } else {
      throw Exception(
          "Une erreur est survenue lors du changement de nom d'utilisateur");
    }
  }

  Future<String?> getImageByUsername(String username) async {
    QuerySnapshot query =
        await usersCollection.where('username', isEqualTo: username).get();
    if (query.docs.isNotEmpty) {
      Map<String, dynamic> user =
          query.docs.first.data() as Map<String, dynamic>;
      return User.fromMap(user).imageUrl;
    } else {
      throw Exception(
          "Erreur lors de la récupération de l'image de profil de l'utilisateur");
    }
  }
}
