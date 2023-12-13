import 'package:flutter/material.dart';

class ReadBlogPage extends StatelessWidget {
  final String uuid;

  ReadBlogPage({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'article $uuid'),
      ),
      body: Center(
        child: Text('ID de l\'article : $uuid'),
      ),
    );
  }
}
