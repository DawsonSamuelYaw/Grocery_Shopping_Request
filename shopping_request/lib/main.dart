import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'providers/grocery_store.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GroceryStore(),
      child: const GroceryApp(),
    ),
  );
}
