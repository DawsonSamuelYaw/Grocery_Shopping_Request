import 'package:flutter/material.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/empty_state.dart';


class OrdersPlaceholderScreen extends StatelessWidget {
  const OrdersPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const EmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'No orders yet',
        message: 'Once checkout is built, your active and past orders will show up here.',
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}
