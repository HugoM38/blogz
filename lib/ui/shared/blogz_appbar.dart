import 'package:flutter/material.dart';

class BlogzAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final bool displayLogo;

  const BlogzAppBar(
      {super.key, this.actions = const [], this.displayLogo = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      leading: displayLogo
          ? Image.asset(
              'logo.png',
              width: 40.0,
              height: 40.0,
            )
          : null,
      title: Text("Blogz",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.bold)),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
