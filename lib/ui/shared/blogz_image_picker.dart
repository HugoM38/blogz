import 'dart:typed_data';

import 'package:flutter/material.dart';

class BlogzImagePicker extends StatefulWidget {
  final VoidCallback pickImage;
  final Uint8List? imageBytes;

  const BlogzImagePicker({super.key, required this.pickImage, required this.imageBytes});
  

  @override
  State<BlogzImagePicker> createState() => _BlogzImagePickerState();
}

class _BlogzImagePickerState extends State<BlogzImagePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.pickImage,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: widget.imageBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    widget.imageBytes!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.add_a_photo, size: 50),
        ),
      ),
    );
  }
}
