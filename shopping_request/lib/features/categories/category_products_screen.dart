import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/product/product_card.dart';
import '../../providers/product_provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  SortOption _sort = SortOption.relevance;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final category = products.categoryById(widget.categoryId);
    var items = products.productsByCategory(widget.categoryId);

    switch (_sort) {
      case SortOption.relevance:
        break;
      case SortOption.priceLowHigh:
        items = [...items]..sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case SortOption.priceHighLow:
        items = [...items]..sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case SortOption.ratingHighLow:
        items = [...items]..sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return Scaffold(
      appBar: AppBar(title: Text(category?.name ?? 'Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              children: [
                Text('${items.length} items', style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                DropdownButton<SortOption>(
                  value: _sort,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(12),
                  items: SortOption.values
                      .map((o) => DropdownMenuItem(value: o, child: Text(o.label, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (value) => setState(() => _sort = value ?? SortOption.relevance),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'Nothing here yet',
                    message: 'This category has no products right now. Check back soon.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) => ProductCard(product: items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
