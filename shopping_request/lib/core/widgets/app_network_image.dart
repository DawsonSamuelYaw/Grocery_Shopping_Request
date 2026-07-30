import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.path,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  bool get isNetworkImage {
    return path.startsWith('http://') ||
        path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (isNetworkImage) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.green,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback();
        },
      );
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallback();
      },
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF0EDE5),
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_grocery_store_outlined,
        size: 48,
        color: AppColors.green,
      ),
    );
  }
}