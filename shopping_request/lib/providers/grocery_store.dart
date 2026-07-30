import 'package:flutter/foundation.dart';

import '../data/mock/mock_products.dart';
import '../data/models/cart_line.dart';
import '../data/models/product.dart';

class GroceryStore extends ChangeNotifier {
  bool darkMode = false;
  bool loggedIn = false;
  int selectedTab = 0;
  String selectedPayment = 'Debit / credit card';
  String selectedDeliveryTime = 'As soon as possible';

  final Set<String> _favourites = {};
  final Map<String, int> _cart = {
    'spinach': 1,
    'banana': 2,
    'bread': 1,
  };

  List<Product> get products => mockProducts;

  List<CartLine> get cartLines => _cart.entries
      .map(
        (entry) => CartLine(
          product: products.firstWhere((p) => p.id == entry.key),
          quantity: entry.value,
        ),
      )
      .toList();

  int get cartCount => _cart.values.fold(0, (a, b) => a + b);

  double get subtotal => cartLines.fold(
        0,
        (total, line) => total + line.product.price * line.quantity,
      );

  double get serviceFee => _cart.isEmpty ? 0 : 2.50;
  double get deliveryFee => _cart.isEmpty ? 0 : 6.00;
  double get total => subtotal + serviceFee + deliveryFee;

  bool isFavourite(String id) => _favourites.contains(id);

  void login() {
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    selectedTab = 0;
    notifyListeners();
  }

  void setTab(int value) {
    selectedTab = value;
    notifyListeners();
  }

  void toggleFavourite(String id) {
    _favourites.contains(id)
        ? _favourites.remove(id)
        : _favourites.add(id);
    notifyListeners();
  }

  void addToCart(Product product, {int amount = 1}) {
    _cart.update(product.id, (value) => value + amount, ifAbsent: () => amount);
    notifyListeners();
  }

  void increase(String productId) {
    _cart.update(productId, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void decrease(String productId) {
    final current = _cart[productId] ?? 0;
    if (current <= 1) {
      _cart.remove(productId);
    } else {
      _cart[productId] = current - 1;
    }
    notifyListeners();
  }

  void setPayment(String value) {
    selectedPayment = value;
    notifyListeners();
  }

  void setDeliveryTime(String value) {
    selectedDeliveryTime = value;
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }
}
