import 'package:flutter/material.dart';

class BlogzAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  const BlogzAppBar({super.key, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Blogz"),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}