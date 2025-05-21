import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class RecipeImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  bool get isNetwork =>
      imageUrl != null &&
      imageUrl!.isNotEmpty &&
      (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'));

  bool get isLocal =>
      imageUrl != null &&
      imageUrl!.isNotEmpty &&
      !isNetwork;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
      );
    }
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
      );
    }
    // Local file
    final file = File(imageUrl!);
    if (!file.existsSync()) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
      );
    }
    return Image.file(
      file,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
    );
  }
}