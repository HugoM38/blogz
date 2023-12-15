import 'package:flutter/material.dart';

class BlogzSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final Function(String) onSearchChanged;

  const BlogzSearchBar({
    Key? key,
    required this.hintText,
    required this.searchController,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme
          .of(context)
          .colorScheme
          .primary,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Theme
                  .of(context)
                  .colorScheme
                  .secondary),
              cursorColor: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  hintText: hintText,
                  hintStyle:
                  TextStyle(color: Theme
                      .of(context)
                      .colorScheme
                      .secondary),
                  suffixIcon: const Icon(Icons.search),
                  suffixIconColor: Theme
                      .of(context)
                      .colorScheme
                      .secondary),
              onChanged: onSearchChanged,
            ),
          ),
        ],
      ),
    );
  }
}