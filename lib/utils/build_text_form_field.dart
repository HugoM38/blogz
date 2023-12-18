import 'package:flutter/material.dart';

enum FieldType { text, password }

Widget buildTextFormField(
  BuildContext context,
  TextEditingController controller,
  String label,
  IconData icon, {
  int maxLines = 1,
  FieldType fieldType = FieldType.text,
  Function(String)? onItemSelected,
}) {
  return TextFormField(
    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
    cursorColor: Theme.of(context).colorScheme.secondary,
    controller: controller,
    decoration: InputDecoration(
      prefixIconColor: Theme.of(context).colorScheme.secondary,
      filled: true,
      fillColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      labelText: label,
      prefixIcon: Icon(icon),
    ),
    maxLines: maxLines,
    obscureText: fieldType == FieldType.password,
  );
}
