import 'package:flutter/material.dart';

class BlogzButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BlogzButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
