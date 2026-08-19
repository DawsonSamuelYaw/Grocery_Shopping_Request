import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Members 2-4: add your feature providers here, e.g.
        // ChangeNotifierProvider(create: (_) => ProductProvider()),
        // ChangeNotifierProvider(create: (_) => CartProvider()),
        // ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const GroceryApp(),
    ),
  );
}
