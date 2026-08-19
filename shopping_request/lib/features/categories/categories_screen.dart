import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../providers/product_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ProductProvider>().categories;
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
        ),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final category = categories[i];
          final count = context.read<ProductProvider>().productsByCategory(category.id).length;
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => context.push(AppRoutes.categoryProducts(category.id)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.mist),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 22, backgroundColor: AppColors.leafLight, child: Icon(category.icon, color: AppColors.leafDark)),
                  const Spacer(),
                  Text(category.name, style: Theme.of(context).textTheme.titleMedium),
                  Text('$count items', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
