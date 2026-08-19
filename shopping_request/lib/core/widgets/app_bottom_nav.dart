import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../../providers/cart_provider.dart';

/// Shared bottom nav for the five top-level tabs. Every tab-root screen
/// (home, categories, cart, orders, profile) should include this so the
/// nav bar stays identical everywhere - don't build a per-screen one.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const _routes = [
    AppRoutes.home,
    AppRoutes.categories,
    AppRoutes.cart,
    AppRoutes.orders,
    AppRoutes.profile,
  ];
  static const _labels = ['Home', 'Categories', 'Cart', 'Orders', 'Profile'];
  static const _icons = [
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.shopping_cart_outlined,
    Icons.receipt_long_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.mist)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_routes.length, (i) {
              final active = i == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: active ? null : () => context.go(_routes[i]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(_icons[i], size: 22, color: active ? AppColors.forest : AppColors.greyText),
                          if (i == 2 && cartCount > 0)
                            Positioned(
                              right: -8,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: const BoxDecoration(color: AppColors.tomato, shape: BoxShape.circle),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text(
                                  '$cartCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _labels[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          color: active ? AppColors.forest : AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
