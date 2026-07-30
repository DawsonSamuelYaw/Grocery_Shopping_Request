import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../providers/grocery_store.dart';

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroceryStore>(
      builder: (context, store, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FreshCart',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: store.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: const OnboardingScreen(),
        );
      },
    );
  }
}
