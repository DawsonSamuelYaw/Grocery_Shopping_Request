import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_loader.dart';
import '../../core/widgets/product/product_card.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      if (provider.isLoading) provider.bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();

    return Scaffold(
      body: SafeArea(
        child: products.isLoading
            ? const AppLoader()
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _HomeHeader()),
                  SliverToBoxAdapter(child: _SearchBar()),
                  SliverToBoxAdapter(child: _PromoBanner()),
                  SliverToBoxAdapter(child: _CategoryRow(categories: products.categories)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Popular near you', style: Theme.of(context).textTheme.headlineSmall),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.categories),
                            child: const Text('See all', style: TextStyle(color: AppColors.leafDark)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ProductCard(product: products.popularProducts[i]),
                        childCount: products.popularProducts.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, size: 18, color: AppColors.leafDark),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deliver to', style: Theme.of(context).textTheme.bodySmall),
                Row(
                  children: [
                    Text('Osu, Accra', style: Theme.of(context).textTheme.titleMedium),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.charcoal),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.charcoal),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.tomato, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(AppRoutes.search),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.mist),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: AppColors.greyText),
              const SizedBox(width: 10),
              Text('Search groceries', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.leaf, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '20% off fresh produce',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text('This week only, while stock lasts', style: TextStyle(color: AppColors.leafLight.withValues(alpha: 0.9), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.local_grocery_store, color: Colors.white, size: 36),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.categories});
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final category = categories[i];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => context.push(AppRoutes.categoryProducts(category.id)),
              borderRadius: BorderRadius.circular(28),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.leafLight,
                    child: Icon(category.icon, color: AppColors.leafDark, size: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(category.name, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
