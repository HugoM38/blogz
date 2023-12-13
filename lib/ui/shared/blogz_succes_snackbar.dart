import 'package:flutter/material.dart';

class BlogzSuccessSnackbar {
  final BuildContext context;

  BlogzSuccessSnackbar(this.context);

  void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }