import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_dialog.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.leafLight,
                  child: Text(
                    (auth.userName ?? auth.userEmail ?? '?').substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 22, color: AppColors.leafDark, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 12),
                Text(auth.userName ?? 'Guest', style: Theme.of(context).textTheme.headlineSmall),
                Text(auth.userEmail ?? '', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.mist),
            ),
            child: SwitchListTile(
              title: const Text('Dark mode'),
              value: app.themeMode == ThemeMode.dark,
              activeColor: AppColors.leaf,
              onChanged: app.toggleDarkMode,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              final confirmed = await AppDialog.confirm(
                context,
                title: 'Log out?',
                message: "You'll need to log in again to place orders.",
                confirmLabel: 'Log out',
              );
              if (confirmed) await auth.logout();
            },
            child: const Text('Log out', style: TextStyle(color: AppColors.tomato, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}
