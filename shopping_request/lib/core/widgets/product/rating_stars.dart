import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 12, this.showValue = true});

  final double rating;
  final double size;
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          return Icon(
            i < full ? Icons.star_rounded : Icons.star_border_rounded,
            size: size,
            color: AppColors.citrus,
          );
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: size, color: AppColors.greyText)),
        ],
      ],
    );
  }
}
