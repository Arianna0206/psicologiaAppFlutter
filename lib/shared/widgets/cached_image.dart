import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedNetworkAsset extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;

  const CachedNetworkAsset({
    super.key,
    required this.url,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.contain,
  });

  bool get isSvg {
    final cleanUrl = Uri.parse(url).path.toLowerCase();
    return cleanUrl.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          final file = snapshot.data!;
          if (isSvg) {
            return SvgPicture.file(
              file,
              width: width,
              height: height,
              fit: fit,
            );
          } else {
            return Image.file(
              file,
              width: width,
              height: height,
              fit: fit,
            );
          }
        } else if (snapshot.hasError) {
          return SizedBox(
            width: width,
            height: height,
            child: const Icon(Icons.error, color: Colors.red),
          );
        } else {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
      },
    );
  }
}
