import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../data/models/cart_line.dart';
import '../../providers/grocery_store.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.line,
  });

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final store = context.read<GroceryStore>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            height: 78,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AppImage(
                path: line.product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.name,
                ),
                Text(
                  line.product.unit,
                  style: const TextStyle(
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  money(line.product.price),
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          QuantitySelector(
            quantity: line.quantity,
            onMinus: () =>
                store.decrease(line.product.id),
            onPlus: () =>
                store.increase(line.product.id),
          ),
        ],
      ),
    );
  }
}