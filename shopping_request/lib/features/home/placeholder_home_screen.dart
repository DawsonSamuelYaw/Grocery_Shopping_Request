import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../providers/auth_provider.dart';

/// TEMPORARY - Member 2 replaces this with the real home dashboard
/// (lib/features/home/home_screen.dart) once the catalogue module is
/// ready. This just proves the router/auth guard chain works end to end.
class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 48, color: AppColors.leaf),
              const SizedBox(height: 16),
              Text('Signed in as ${auth.userName ?? auth.userEmail ?? 'guest'}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Foundation, theme, router and auth are wired up.\nThis screen is a placeholder for the home dashboard.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Log out', variant: AppButtonVariant.secondary, onPressed: auth.logout),
            ],
          ),
        ),
      ),
    );
  }
}
