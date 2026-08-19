import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';

/// Integrates every feature route into the final application.
/// Members: don't wrap MaterialApp again in your own screens - this is
/// the single root widget.
class GroceryApp extends StatefulWidget {
  const GroceryApp({super.key});

  @override
  State<GroceryApp> createState() => _GroceryAppState();
}

class _GroceryAppState extends State<GroceryApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final appProvider = context.read<AppProvider>();
    final authProvider = context.read<AuthProvider>();
    _router = buildAppRouter(appProvider: appProvider, authProvider: authProvider);
    appProvider.bootstrap();
    authProvider.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    return MaterialApp.router(
      title: 'Group 10 Grocery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appProvider.themeMode,
      routerConfig: _router,
    );
  }
}
