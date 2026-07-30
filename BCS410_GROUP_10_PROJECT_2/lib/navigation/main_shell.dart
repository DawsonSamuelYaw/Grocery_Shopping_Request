import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/cart/cart_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/home/home_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/profile/profile_screen.dart';
import '../providers/grocery_store.dart';
import 'widgets/grocery_bottom_navigation.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroceryStore>(
      builder: (context, store, _) {
        const screens = [
          HomeScreen(),
          CategoriesScreen(),
          CartScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: store.selectedTab,
            children: screens,
          ),
          bottomNavigationBar: GroceryBottomNavigation(
            currentIndex: store.selectedTab,
            cartCount: store.cartCount,
            onTap: store.setTab,
          ),
        );
      },
    );
  }
}
