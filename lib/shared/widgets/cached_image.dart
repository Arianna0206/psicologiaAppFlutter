import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedNetworkAsset extends StatefulWidget {
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

  @override
  State<CachedNetworkAsset> createState() => _CachedNetworkAssetState();
}

class _CachedNetworkAssetState extends State<CachedNetworkAsset> {
  late Future<File> _cachedFileFuture;

  bool get isSvg {
    final cleanUrl = Uri.parse(widget.url).path.toLowerCase();
    return cleanUrl.endsWith('.svg');
  }

  @override
  void initState() {
    super.initState();
    _cachedFileFuture = DefaultCacheManager().getSingleFile(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _cachedFileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          final file = snapshot.data!;
          if (isSvg) {
            return SvgPicture.file(
              file,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
            );
          } else {
            return Image.file(
              file,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
            );
          }
        } else if (snapshot.hasError) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Icon(Icons.error, color: Colors.red),
          );
        } else {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
      },
    );
  }
}

