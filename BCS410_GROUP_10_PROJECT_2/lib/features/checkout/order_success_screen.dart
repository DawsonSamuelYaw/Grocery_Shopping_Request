import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/primary_button.dart';
import '../../navigation/main_shell.dart';
import '../../providers/grocery_store.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 56,
                backgroundColor: AppColors.softGreen,
                child: Icon(
                  Icons.check,
                  size: 58,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Order placed!',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your order of ${money(total)} has been received.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                label: 'View orders',
                onPressed: () {
                  context.read<GroceryStore>().setTab(3);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainShell()),
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
