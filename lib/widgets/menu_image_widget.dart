import 'package:flutter/material.dart';
import 'dart:convert';

/// Widget gambar menu yang support URL (http) dan Base64 data URI
/// Digunakan agar foto yang diupload kasir tetap tampil meski backend offline
class MenuImageWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double iconSize;

  const MenuImageWidget({
    super.key,
    required this.imageUrl,
    this.height = 180,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: width ?? double.infinity,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Icon(Icons.restaurant, size: iconSize, color: Colors.grey),
    );

    Widget img;

    if (imageUrl.startsWith('data:image')) {
      // Gambar tersimpan lokal sebagai Base64
      try {
        final base64Data = imageUrl.split(',').last;
        final bytes = base64Decode(base64Data);
        img = Image.memory(
          bytes,
          height: height,
          width: width ?? double.infinity,
          fit: fit,
          errorBuilder: (_, __, ___) => placeholder,
        );
      } catch (_) {
        img = placeholder;
      }
    } else if (imageUrl.startsWith('http')) {
      // Gambar dari server
      img = Image.network(
        imageUrl,
        height: height,
        width: width ?? double.infinity,
        fit: fit,
        errorBuilder: (ctx, err, stack) => placeholder,
      );
    } else if (imageUrl.startsWith('assets/')) {
      // Gambar bawaan lokal (assets)
      img = Image.asset(
        imageUrl,
        height: height,
        width: width ?? double.infinity,
        fit: fit,
        errorBuilder: (ctx, err, stack) => placeholder,
      );
    } else {
      img = placeholder;
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}
