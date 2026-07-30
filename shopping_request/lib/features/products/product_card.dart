import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../data/models/product.dart';
import '../../providers/grocery_store.dart';
import 'product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2EEE5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AppNetworkImage(url: product.imageUrl),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton.filled(
                      onPressed: () => store.toggleFavourite(product.id),
                      icon: Icon(
                        store.isFavourite(product.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              money(product.price),
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton.filled(
                onPressed: () => store.addToCart(product),
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
