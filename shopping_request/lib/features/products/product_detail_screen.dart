import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../data/models/product.dart';
import '../../providers/grocery_store.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => store.toggleFavourite(widget.product.id),
            icon: Icon(
              store.isFavourite(widget.product.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: AppColors.red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 360,
                  child: AppNetworkImage(url: widget.product.imageUrl),
                ),
                Padding(
                  padding: const EdgeInsets.all(34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text(
                            money(widget.product.price),
                            style: const TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 26,
                            ),
                          ),
                          const Spacer(),
                          QuantitySelector(
                            quantity: quantity,
                            onMinus: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                            onPlus: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'About this item',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton(
              label: 'Add to cart',
              onPressed: () =>
                  store.addToCart(widget.product, amount: quantity),
            ),
          ),
        ],
      ),
    );
  }
}
