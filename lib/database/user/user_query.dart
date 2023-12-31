import 'package:blogz/database/database.dart';
import 'package:blogz/database/user/user.dart';
import 'package:blogz/utils/hash_password.dart';
import 'package:blogz/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserQuery {
  final CollectionReference _usersCollection =
      Database().firestore.collection('Users');

  Future<void> signup(User user) async {
    final Exception exception = Exception("Erreur lors de l'inscription");

    final QuerySnapshot query = await _usersCollection
        .where('username', isEqualTo: user.username)
        .get()
        .catchError((error) {
      throw exception;
    });

    if (query.docs.isEmpty) {
      await _usersCollection.add(user.toMap()).catchError((error) {
        throw exception;
      });
    } else {
      throw Exception('Il existe déjà un utilisateur avec ce nom');
    }
  }

  Future<User> signin(String username, String password) async {
    final QuerySnapshot query = await _usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get()
        .catchError((error) {
      throw Exception('Erreur lors de la connexion');
    });

    if (query.docs.isNotEmpty) {
      final Map<String, dynamic> user =
          query.docs.first.data() as Map<String, dynamic>;
      return User.fromMap(user);
    } else {
      throw Exception("Nom d'utilisateur ou mot de passe incorrect");
    }
  }

  Future<void> changeImage(String imageUrl) async {
    final Exception exception = Exception("Erreur lors du changement d'image");

    final QuerySnapshot query = await _usersCollection
        .where('username', isEqualTo: SharedPrefs().getCurrentUser())
        .get()
        .catchError((error) {
      throw exception;
    });

    if (query.docs.isNotEmpty) {
      _usersCollection
          .doc(query.docs.first.id)
          .update({'imageUrl': imageUrl}).catchError((error) {
        throw exception;
      });
    } else {
      throw exception;
    }
  }

  Future<void> passwordUpdate(
      String username, String oldPassword, String newPassword) async {
    final Exception exception =
        Exception('Une erreur est survenue lors du changement de mot de passe');

    final QuerySnapshot query = await _usersCollection
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: hashPassword(oldPassword))
        .get()
        .catchError((error) {
      throw exception;
    });

    if (query.docs.isNotEmpty) {
      _usersCollection
          .doc(query.docs.first.id)
          .update({'password': hashPassword(newPassword)}).catchError((error) {
        throw exception;
      });
    } else {
      throw exception;
    }
  }

  Future<void> usernameUpdate(String username, String newUsername) async {
    final Exception exception = Exception(
        "Une erreur est survenue lors du changement de nom d'utilisateur");

    final QuerySnapshot query = await _usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw exception;
    });

    final QuerySnapshot queryNewUsername = await _usersCollection
        .where('username', isEqualTo: newUsername)
        .get()
        .catchError((error) {
      throw exception;
    });
    if (query.docs.isNotEmpty && queryNewUsername.docs.isEmpty) {
      await _usersCollection
          .doc(query.docs.first.id)
          .update({'username': newUsername}).catchError((error) {
        throw exception;
      });
    } else {
      throw exception;
    }
  }

  Future<String?> getImageByUsername(String username) async {
    final Exception exception = Exception(
        "Erreur lors de la récupération de l'image de profil de l'utilisateur");

    final QuerySnapshot query = await _usersCollection
        .where('username', isEqualTo: username)
        .get()
        .catchError((error) {
      throw exception;
    });
    if (query.docs.isNotEmpty) {
      final Map<String, dynamic> user =
          query.docs.first.data() as Map<String, dynamic>;
      return User.fromMap(user).imageUrl;
    } else {
      throw exception;
    }
  }
}
