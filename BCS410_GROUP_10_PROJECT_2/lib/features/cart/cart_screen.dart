import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/summary_row.dart';
import '../../providers/grocery_store.dart';
import '../checkout/checkout_screen.dart';
import 'cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your cart',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${store.cartLines.length} items',
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ...store.cartLines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CartItemCard(line: line),
            ),
          ),
          const SizedBox(height: 12),
          SummaryRow(label: 'Subtotal', value: store.subtotal),
          SummaryRow(label: 'Service fee', value: store.serviceFee),
          SummaryRow(label: 'Delivery fee', value: store.deliveryFee),
          const Divider(height: 30),
          SummaryRow(label: 'Total', value: store.total, emphasized: true),
          const SizedBox(height: 80),
          PrimaryButton(
            label: 'Proceed to checkout',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CheckoutScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
