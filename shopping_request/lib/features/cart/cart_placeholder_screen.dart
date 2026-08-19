import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/product/product_thumbnail.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';


class CartPlaceholderScreen extends StatelessWidget {
  const CartPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = context.watch<ProductProvider>();
    final entries = cart.quantities.entries.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Your cart (${cart.itemCount})')),
      body: entries.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              message: 'Add items from the home screen or a category to see them here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final product = products.productById(entries[i].key);
                final qty = entries[i].value;
                if (product == null) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.mist),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: ProductThumbnail(product: product, categories: products.categories, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: Theme.of(context).textTheme.bodyLarge),
                            Text('Qty $qty · GHS ${product.discountedPrice.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => cart.removeItem(product.id),
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.greyText),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}
