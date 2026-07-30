import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_network_image.dart';
import '../../providers/grocery_store.dart';
import '../products/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _itemsPerPage = 6;

  final TextEditingController _searchController = TextEditingController();

  String query = '';
  int _currentPage = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      query = value;
      _currentPage = 0;
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      query = '';
      _currentPage = 0;
    });
  }

  void _changePage(int page, int totalPages) {
    if (page < 0 || page >= totalPages) {
      return;
    }

    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    final normalizedQuery = query.trim().toLowerCase();

    final filteredProducts = store.products.where((product) {
      final productName = product.name.toLowerCase();
      final productUnit = product.unit.toLowerCase();
      final productDescription = product.description.toLowerCase();

      return productName.contains(normalizedQuery) ||
          productUnit.contains(normalizedQuery) ||
          productDescription.contains(normalizedQuery);
    }).toList();

    final totalPages = filteredProducts.isEmpty
        ? 0
        : (filteredProducts.length / _itemsPerPage).ceil();

    final safeCurrentPage = totalPages == 0
        ? 0
        : _currentPage.clamp(0, totalPages - 1);

    final startIndex = safeCurrentPage * _itemsPerPage;

    final endIndex = math.min(
      startIndex + _itemsPerPage,
      filteredProducts.length,
    );

    final visibleProducts = filteredProducts.isEmpty
        ? <dynamic>[]
        : filteredProducts.sublist(startIndex, endIndex);

    return SafeArea(
      child: ListView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        children: [
          const _HomeHeader(),

          const SizedBox(height: 20),

          _SearchField(
            controller: _searchController,
            query: query,
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),

          const SizedBox(height: 20),

          const _PromotionalBanner(),

          const SizedBox(height: 28),

          const _SectionHeading(
            title: 'Shop by category',
          ),

          const SizedBox(height: 14),

          const _CategorySection(),

          const SizedBox(height: 28),

          _ProductsHeading(
            totalItems: filteredProducts.length,
            startIndex: filteredProducts.isEmpty
                ? 0
                : startIndex + 1,
            endIndex: endIndex,
          ),

          const SizedBox(height: 16),

          if (filteredProducts.isEmpty)
            _NoProductsFound(
              onClearSearch: query.isNotEmpty ? _clearSearch : null,
            )
          else ...[
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;

                final crossAxisCount =
                availableWidth >= 900
                    ? 4
                    : availableWidth >= 600
                    ? 3
                    : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: visibleProducts.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio:
                    crossAxisCount == 2 ? 0.70 : 0.74,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: visibleProducts[index],
                    );
                  },
                );
              },
            ),

            if (totalPages > 1) ...[
              const SizedBox(height: 28),

              _PaginationControls(
                currentPage: safeCurrentPage,
                totalPages: totalPages,
                onPageSelected: (page) {
                  _changePage(page, totalPages);
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: AppColors.softGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.location_on_outlined,
            color: AppColors.darkGreen,
            size: 23,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Deliver to',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Madina, Accra',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 17,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Material(
          color: AppColors.softGreen,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: const SizedBox(
              width: 46,
              height: 46,
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.darkGreen,
                size: 23,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search groceries',
        prefixIcon: const Icon(
          Icons.search_rounded,
        ),
        suffixIcon: query.isNotEmpty
            ? IconButton(
          tooltip: 'Clear search',
          onPressed: onClear,
          icon: const Icon(
            Icons.close_rounded,
          ),
        )
            : null,
      ),
    );
  }
}

class _PromotionalBanner extends StatelessWidget {
  const _PromotionalBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF174D3B),
        ),
        child: AspectRatio(
          // Keeps the complete banner visible without cropping.
          aspectRatio: 2.1,
          child: const AppImage(
            path:
            'assets/images/banners/fresh_produce_banner.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.darkGreen,
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection();

  static const categories = [
    (
    name: 'Fruit',
    image: 'assets/images/categories/fruit.png',
    ),
    (
    name: 'Vegetables',
    image: 'assets/images/categories/vegetables.png',
    ),
    (
    name: 'Dairy',
    image: 'assets/images/categories/dairy.png',
    ),
    (
    name: 'Bakery',
    image: 'assets/images/categories/bakery.png',
    ),
    (
    name: 'Meat',
    image: 'assets/images/categories/meat.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 14);
        },
        itemBuilder: (context, index) {
          final category = categories[index];

          return _CategoryItem(
            name: category.name,
            imagePath: category.image,
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.name,
    required this.imagePath,
  });

  final String name;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(19),
            ),
            child: AppImage(
              path: imagePath,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 7),

          SizedBox(
            width: 76,
            height: 20,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontSize: 12.5,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsHeading extends StatelessWidget {
  const _ProductsHeading({
    required this.totalItems,
    required this.startIndex,
    required this.endIndex,
  });

  final int totalItems;
  final int startIndex;
  final int endIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Text(
            'Popular near you',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 21,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Text(
          totalItems == 0
              ? '0 items'
              : '$startIndex–$endIndex of $totalItems',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 13,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  List<int> _visiblePages() {
    if (totalPages <= 5) {
      return List.generate(
        totalPages,
            (index) => index,
      );
    }

    if (currentPage <= 2) {
      return [0, 1, 2, 3, 4];
    }

    if (currentPage >= totalPages - 3) {
      return [
        totalPages - 5,
        totalPages - 4,
        totalPages - 3,
        totalPages - 2,
        totalPages - 1,
      ];
    }

    return [
      currentPage - 2,
      currentPage - 1,
      currentPage,
      currentPage + 1,
      currentPage + 2,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _visiblePages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PaginationArrow(
          icon: Icons.chevron_left_rounded,
          enabled: currentPage > 0,
          tooltip: 'Previous page',
          onPressed: () {
            onPageSelected(currentPage - 1);
          },
        ),

        const SizedBox(width: 8),

        Flexible(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 7,
            runSpacing: 7,
            children: pages.map((page) {
              final isSelected = page == currentPage;

              return Material(
                color: isSelected
                    ? AppColors.green
                    : AppColors.softGreen,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    onPageSelected(page);
                  },
                  child: SizedBox(
                    width: 38,
                    height: 38,
                    child: Center(
                      child: Text(
                        '${page + 1}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.darkGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(width: 8),

        _PaginationArrow(
          icon: Icons.chevron_right_rounded,
          enabled: currentPage < totalPages - 1,
          tooltip: 'Next page',
          onPressed: () {
            onPageSelected(currentPage + 1);
          },
        ),
      ],
    );
  }
}

class _PaginationArrow extends StatelessWidget {
  const _PaginationArrow({
    required this.icon,
    required this.enabled,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: const Size(40, 40),
        backgroundColor: enabled
            ? AppColors.softGreen
            : AppColors.border.withValues(alpha: 0.45),
        foregroundColor: enabled
            ? AppColors.darkGreen
            : AppColors.muted.withValues(alpha: 0.5),
      ),
    );
  }
}

class _NoProductsFound extends StatelessWidget {
  const _NoProductsFound({
    this.onClearSearch,
  });

  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: AppColors.softGreen.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 62,
            color: AppColors.muted,
          ),

          const SizedBox(height: 14),

          const Text(
            'No groceries found',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Try searching for another product.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          if (onClearSearch != null) ...[
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: onClearSearch,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Clear search',
              ),
            ),
          ],
        ],
      ),
    );
  }
}