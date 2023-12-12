import 'package:flutter/material.dart';

class BlogzAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;

  const BlogzAppBar({super.key, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text("Blogz",
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 30, fontWeight: FontWeight.bold)),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
