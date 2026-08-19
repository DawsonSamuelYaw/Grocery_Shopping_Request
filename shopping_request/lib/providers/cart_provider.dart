import 'package:flutter/material.dart';
import '../models/product.dart';


class CartProvider extends ChangeNotifier {
  final Map<String, int> _quantities = {}; // productId -> quantity

  Map<String, int> get quantities => Map.unmodifiable(_quantities);

  int get itemCount => _quantities.values.fold(0, (sum, qty) => sum + qty);

  int quantityOf(String productId) => _quantities[productId] ?? 0;

  void addItem(Product product, {int quantity = 1}) {
    _quantities.update(product.id, (qty) => qty + quantity, ifAbsent: () => quantity);
    notifyListeners();
  }

  void removeItem(String productId) {
    _quantities.remove(productId);
    notifyListeners();
  }

  void clear() {
    _quantities.clear();
    notifyListeners();
  }
}