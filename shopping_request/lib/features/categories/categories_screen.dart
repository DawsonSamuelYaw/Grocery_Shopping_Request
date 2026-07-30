import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/grocery_store.dart';
import '../products/product_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String selected = 'All';
  final categories = const ['All', 'Fruit', 'Veg', 'Dairy', 'Bakery', 'Meat'];

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();
    final products = selected == 'All'
        ? store.products
        : store.products.where((p) => p.category == selected).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: categories.map((category) {
              return ChoiceChip(
                label: Text(category),
                selected: selected == category,
                onSelected: (_) => setState(() => selected = category),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .72,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (_, index) => ProductCard(product: products[index]),
          ),
        ],
      ),
    );
  }
}
