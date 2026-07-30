import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(36, 30, 36, 24),
        children: [
          const Text(
            'Orders',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #GA10432'),
                SizedBox(height: 6),
                Text(
                  'On the way',
                  style: TextStyle(color: AppColors.green),
                ),
                SizedBox(height: 18),
                LinearProgressIndicator(
                  value: .75,
                  color: AppColors.green,
                ),
                SizedBox(height: 16),
                Text('3 items · GHS 50.50'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Recent orders',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 14),
          const ListTile(
            title: Text('Order #GA10388'),
            subtitle: Text('Delivered · Jul 21'),
            trailing: Text('GHS 33.20'),
          ),
          const ListTile(
            title: Text('Order #GA10351'),
            subtitle: Text('Delivered · Jul 14'),
            trailing: Text('GHS 27.90'),
          ),
        ],
      ),
    );
  }
}
