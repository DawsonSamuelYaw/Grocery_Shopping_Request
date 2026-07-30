import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/grocery_store.dart';
import '../checkout/checkout_screen.dart';
import 'cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() =>
      _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController =
  TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode(GroceryStore store) {
    FocusScope.of(context).unfocus();

    final result = store.applyPromoCode(
      _promoController.text,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success
              ? AppColors.green
              : AppColors.red,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
          constraints.maxWidth >= 700 ? 40.0 : 20.0;

          if (store.isCartEmpty) {
            return _EmptyCartState(
              onBrowseProducts: () {
                store.setTab(0);
              },
            );
          }

          return ListView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              32,
            ),
            children: [
              _CartHeader(
                cartCount: store.cartCount,
              ),

              const SizedBox(height: 24),

              ...store.cartLines.map(
                    (line) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 14,
                  ),
                  child: CartItemCard(line: line),
                ),
              ),

              const SizedBox(height: 10),

              _PromoCodeCard(
                controller: _promoController,
                appliedCode: store.appliedPromoCode,
                onApply: () {
                  _applyPromoCode(store);
                },
                onRemove: () {
                  _promoController.clear();
                  store.removePromoCode();
                },
              ),

              const SizedBox(height: 22),

              _CartSummaryCard(store: store),

              const SizedBox(height: 24),

              PrimaryButton(
                label: 'Proceed to checkout',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const CheckoutScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Taxes and delivery charges are included.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted.withValues(
                      alpha: 0.9,
                    ),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({
    required this.cartCount,
  });

  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your cart',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 29,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Review your items before checkout.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '$cartCount ${cartCount == 1 ? 'item' : 'items'}',
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoCodeCard extends StatelessWidget {
  const _PromoCodeCard({
    required this.controller,
    required this.appliedCode,
    required this.onApply,
    required this.onRemove,
  });

  final TextEditingController controller;
  final String? appliedCode;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasPromo = appliedCode != null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: AppColors.green,
                size: 21,
              ),
              SizedBox(width: 9),
              Text(
                'Promo code',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Try SAVE10, GROCERY5 or FREEDELIVERY.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 14),
          if (hasPromo)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.green,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$appliedCode applied',
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onRemove,
                    child: const Text('Remove'),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textCapitalization:
                    TextCapitalization.characters,
                    textInputAction:
                    TextInputAction.done,
                    onSubmitted: (_) {
                      onApply();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter promo code',
                      prefixIcon: Icon(
                        Icons.confirmation_number_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: onApply,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    AppColors.darkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({
    required this.store,
  });

  final GroceryStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          _SummaryLine(
            label: 'Subtotal',
            value: money(store.subtotal),
          ),
          const SizedBox(height: 13),
          _SummaryLine(
            label: 'Service fee',
            value: money(store.serviceFee),
          ),
          const SizedBox(height: 13),
          _SummaryLine(
            label: 'Delivery fee',
            value: money(store.deliveryFee),
          ),
          if (store.discount > 0) ...[
            const SizedBox(height: 13),
            _SummaryLine(
              label: 'Discount',
              value: '-${money(store.discount)}',
              valueColor: AppColors.green,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Divider(
              height: 1,
              color: AppColors.border,
            ),
          ),
          _SummaryLine(
            label: 'Total',
            value: money(store.total),
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool emphasized;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: emphasized
                ? AppColors.darkGreen
                : AppColors.muted,
            fontSize: emphasized ? 17 : 14,
            fontWeight: emphasized
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor ??
                AppColors.darkGreen,
            fontSize: emphasized ? 18 : 14,
            fontWeight: emphasized
                ? FontWeight.w700
                : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState({
    required this.onBrowseProducts,
  });

  final VoidCallback onBrowseProducts;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 40,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 118,
              height: 118,
              decoration: const BoxDecoration(
                color: AppColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.darkGreen,
                size: 54,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your cart is empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Add grocery items to your cart and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: 220,
              child: PrimaryButton(
                label: 'Browse products',
                icon: Icons.storefront_outlined,
                onPressed: onBrowseProducts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}