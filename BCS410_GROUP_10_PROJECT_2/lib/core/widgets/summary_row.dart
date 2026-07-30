import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final double value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: emphasized ? AppColors.darkGreen : AppColors.muted,
                fontSize: emphasized ? 18 : 16,
              ),
            ),
          ),
          Text(
            money(value),
            style: TextStyle(
              color: emphasized ? AppColors.darkGreen : Colors.black87,
              fontSize: emphasized ? 18 : 15,
              fontWeight: emphasized ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
