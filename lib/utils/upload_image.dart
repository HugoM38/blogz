import 'dart:typed_data';

import 'package:blogz/database/database.dart';

Future<String?> uploadImage(
    Uint8List imageBytes, String fileName, String? imageExtension) async {
  try {
    String fileNameWithExtension = fileName + (imageExtension ?? '.jpg');

    final ref =
        Database().firebaseStorage.ref().child('images/$fileNameWithExtension');

    final result = await ref.putData(imageBytes);

    return await result.ref.getDownloadURL();
  } catch (_) {
    throw Exception("Envoie de l'image impossible");
  }
}
