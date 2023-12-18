import 'package:flutter/material.dart';

class BlogzErrorSnackbar {
  final BuildContext context;

  BlogzErrorSnackbar(this.context);

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
