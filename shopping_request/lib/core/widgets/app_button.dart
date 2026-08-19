import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, text }

/// Shared button used across every module so CTAs look identical whether
/// they come from checkout, auth, or settings.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
              Text(label),
            ],
          );

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: isLoading ? null : onPressed, child: child),
        );
      case AppButtonVariant.secondary:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              shape: const StadiumBorder(),
              side: const BorderSide(color: AppColors.mist),
              foregroundColor: AppColors.charcoal,
            ),
            child: child,
          ),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(label, style: const TextStyle(color: AppColors.leafDark, fontWeight: FontWeight.w500)),
        );
    }
  }
}
