import 'package:flutter/material.dart';
import 'app_button.dart';

/// Shared confirm dialog - e.g. "Log out?", "Remove item?", "Cancel order?".
class AppDialog {
  AppDialog._();

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Expanded(
            child: AppButton(
              label: cancelLabel,
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              label: confirmLabel,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
