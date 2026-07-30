import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
  });

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.green,
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF0EDE5),
        alignment: Alignment.center,
        child: const Icon(
          Icons.local_grocery_store_outlined,
          size: 48,
          color: AppColors.green,
        ),
      ),
    );
  }
}
