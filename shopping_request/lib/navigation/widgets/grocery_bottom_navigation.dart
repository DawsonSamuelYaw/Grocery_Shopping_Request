import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class GroceryBottomNavigation extends StatelessWidget {
  const GroceryBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_outlined, 'Home'),
      (Icons.grid_view_outlined, 'Categories'),
      (Icons.shopping_cart_outlined, 'Cart'),
      (Icons.receipt_long_outlined, 'Orders'),
      (Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 14),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = index == currentIndex;
            final item = items[index];

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.softGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            item.$1,
                            color: selected
                                ? AppColors.darkGreen
                                : AppColors.muted,
                          ),
                        ),
                        if (index == 2 && cartCount > 0)
                          Positioned(
                            right: 2,
                            top: -6,
                            child: CircleAvatar(
                              radius: 9,
                              backgroundColor: AppColors.red,
                              child: Text(
                                '$cartCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.$2,
                      style: TextStyle(
                        color: selected
                            ? AppColors.darkGreen
                            : AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
