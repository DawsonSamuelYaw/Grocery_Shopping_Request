import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 28});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 2.6, color: AppColors.leaf),
      ),
    );
  }
}
