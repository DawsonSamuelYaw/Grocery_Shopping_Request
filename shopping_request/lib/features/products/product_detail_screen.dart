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
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    final totalPrice = widget.product.price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          IconButton(
            onPressed: () {
              store.toggleFavourite(widget.product.id);
            },
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
                Container(
                  height: 360,
                  margin: const EdgeInsets.fromLTRB(
                    24,
                    12,
                    24,
                    0,
                  ),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EEE5),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: AppImage(
                    path: widget.product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    28,
                    28,
                    28,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 26,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product.unit,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              money(widget.product.price),
                              style: const TextStyle(
                                color: AppColors.darkGreen,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          QuantitySelector(
                            quantity: quantity,
                            onMinus: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            onPlus: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'About this item',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 15,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              24,
              16,
              24,
              24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: AppColors.border,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: PrimaryButton(
                label: 'Add to cart • ${money(totalPrice)}',
                onPressed: () {
                  store.addToCart(
                    widget.product,
                    amount: quantity,
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '$quantity × ${widget.product.name} added to cart',
                        ),
                        duration: const Duration(
                          seconds: 2,
                        ),
                      ),
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}