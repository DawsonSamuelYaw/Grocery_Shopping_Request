import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/product/product_thumbnail.dart';
import '../../core/widgets/product/rating_stars.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedUnitIndex = 0;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final product = products.productById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This product is no longer available.')),
      );
    }

    final units = product.availableUnits.isNotEmpty ? product.availableUnits : [product.unit];
    final total = product.discountedPrice * _quantity;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.mistFill,
            leading: _RoundIconButton(icon: Icons.arrow_back_ios_new, onTap: () => context.pop()),
            actions: [
              _RoundIconButton(
                icon: product.isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                iconColor: AppColors.tomato,
                onTap: () => products.toggleFavourite(product.id),
              ),
              const SizedBox(width: 12),
            ],
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              background: ProductThumbnail(product: product, categories: products.categories, size: 88),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.inStock ? AppColors.leafLight : AppColors.mist,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.inStock ? 'In stock' : 'Out of stock',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: product.inStock ? AppColors.leafDark : AppColors.greyText,
                          ),
                        ),
                      ),
                      const Spacer(),
                      RatingStars(rating: product.rating, size: 13),
                      const SizedBox(width: 4),
                      Text('(${product.reviewCount})', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('GHS ${product.discountedPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displaySmall),
                      if (product.onSale) ...[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'GHS ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.greyText,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      _QuantityStepper(
                        quantity: _quantity,
                        onChanged: (q) => setState(() => _quantity = q),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text('Pack size', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: List.generate(units.length, (i) {
                      final active = i == _selectedUnitIndex;
                      return ChoiceChip(
                        label: Text(units[i]),
                        selected: active,
                        onSelected: (_) => setState(() => _selectedUnitIndex = i),
                        selectedColor: AppColors.leaf,
                        labelStyle: TextStyle(color: active ? Colors.white : AppColors.charcoal, fontWeight: FontWeight.w500),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: active ? AppColors.leaf : AppColors.mist),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 22),
                  Text('About this item', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'No additional details for this product yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.mist)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total', style: Theme.of(context).textTheme.bodySmall),
                Text('GHS ${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                label: product.inStock ? 'Add to cart' : 'Out of stock',
                onPressed: product.inStock
                    ? () {
                        context.read<CartProvider>().addItem(product, quantity: _quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.name} added to cart'), backgroundColor: AppColors.forest),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onChanged});
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.mist)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 16,
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            iconSize: 16,
            onPressed: () => onChanged(quantity + 1),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap, this.iconColor});
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(iconSize: 16, onPressed: onTap, icon: Icon(icon, color: iconColor ?? AppColors.charcoal)),
      ),
    );
  }
}
