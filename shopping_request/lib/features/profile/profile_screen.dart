import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/grocery_store.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(38, 30, 38, 30),
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 26),
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.softGreen,
              child: Text(
                'AB',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('Ab Razak')),
          const Center(
            child: Text(
              'iddrissarazak@gmail.com',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 30),
          const ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Saved addresses'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Payment methods'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text('Favourites'),
            trailing: Icon(Icons.chevron_right),
          ),
          SwitchListTile(
            title: const Text('Dark mode'),
            value: store.darkMode,
            onChanged: store.toggleDarkMode,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.red),
            title: const Text(
              'Log out',
              style: TextStyle(color: AppColors.red),
            ),
            onTap: () {
              store.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
