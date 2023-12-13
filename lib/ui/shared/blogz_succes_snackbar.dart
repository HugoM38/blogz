import 'package:flutter/material.dart';

class BlogzSuccesSnackbar {
  final BuildContext context;

  BlogzSuccesSnackbar(this.context);

  void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }