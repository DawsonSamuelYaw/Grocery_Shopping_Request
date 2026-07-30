import 'package:flutter/foundation.dart';

import '../data/mock/mock_products.dart';
import '../data/models/cart_line.dart';
import '../data/models/product.dart';





class GroceryStore extends ChangeNotifier {
  bool darkMode = false;
  bool loggedIn = false;
  int selectedTab = 0;

  String selectedPayment = 'Mobile Money';
  String selectedDeliveryTime = 'As soon as possible';

  String? appliedPromoCode;
  double discount = 0;

  final Set<String> _favourites = {};

  final Map<String, int> _cart = {
    'spinach': 1,
    'banana': 2,
    'bread': 1,
  };


  List<Product> get favouriteProducts {
    return products.where(
          (product) => _favourites.contains(product.id),
    ).toList();
  }

  int get favouriteCount => _favourites.length;

  void removeFavourite(String productId) {
    _favourites.remove(productId);
    notifyListeners();
  }
  

  List<Product> get products => mockProducts;

  List<CartLine> get cartLines {
    return _cart.entries.map((entry) {
      return CartLine(
        product: products.firstWhere(
              (product) => product.id == entry.key,
        ),
        quantity: entry.value,
      );
    }).toList();
  }

  bool get isCartEmpty => _cart.isEmpty;

  int get cartCount {
    return _cart.values.fold(
      0,
          (total, quantity) => total + quantity,
    );
  }

  double get subtotal {
    return cartLines.fold(
      0,
          (total, line) {
        return total +
            (line.product.price * line.quantity);
      },
    );
  }

  double get serviceFee {
    return _cart.isEmpty ? 0 : 2.50;
  }

  double get deliveryFee {
    return _cart.isEmpty ? 0 : 6.00;
  }

  double get totalBeforeDiscount {
    return subtotal + serviceFee + deliveryFee;
  }

  double get total {
    final calculatedTotal =
        totalBeforeDiscount - discount;

    return calculatedTotal < 0 ? 0 : calculatedTotal;
  }

  bool isFavourite(String id) {
    return _favourites.contains(id);
  }

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
    if (_favourites.contains(id)) {
      _favourites.remove(id);
    } else {
      _favourites.add(id);
    }

    notifyListeners();
  }

  void addToCart(
      Product product, {
        int amount = 1,
      }) {
    if (amount <= 0) {
      return;
    }

    _cart.update(
      product.id,
          (value) => value + amount,
      ifAbsent: () => amount,
    );

    _recalculateDiscount();
    notifyListeners();
  }

  void increase(String productId) {
    _cart.update(
      productId,
          (value) => value + 1,
      ifAbsent: () => 1,
    );

    _recalculateDiscount();
    notifyListeners();
  }

  void decrease(String productId) {
    final current = _cart[productId] ?? 0;

    if (current <= 1) {
      _cart.remove(productId);
    } else {
      _cart[productId] = current - 1;
    }

    _recalculateDiscount();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);

    _recalculateDiscount();
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

  PromoResult applyPromoCode(String code) {
    final normalizedCode =
    code.trim().toUpperCase();

    if (_cart.isEmpty) {
      return const PromoResult(
        success: false,
        message: 'Add products before applying a promo code.',
      );
    }

    switch (normalizedCode) {
      case 'SAVE10':
        appliedPromoCode = normalizedCode;
        discount = subtotal * 0.10;

        notifyListeners();

        return const PromoResult(
          success: true,
          message: 'SAVE10 applied. You received 10% off.',
        );

      case 'GROCERY5':
        appliedPromoCode = normalizedCode;
        discount = subtotal >= 30 ? 5 : 0;

        if (discount == 0) {
          appliedPromoCode = null;

          return const PromoResult(
            success: false,
            message:
            'Spend at least GHS 30.00 to use GROCERY5.',
          );
        }

        notifyListeners();

        return const PromoResult(
          success: true,
          message: 'GROCERY5 applied. GHS 5.00 deducted.',
        );

      case 'FREEDELIVERY':
        appliedPromoCode = normalizedCode;
        discount = deliveryFee;

        notifyListeners();

        return const PromoResult(
          success: true,
          message: 'Free delivery applied successfully.',
        );

      default:
        return const PromoResult(
          success: false,
          message: 'The promo code is invalid.',
        );
    }
  }

  void removePromoCode() {
    appliedPromoCode = null;
    discount = 0;
    notifyListeners();
  }

  void _recalculateDiscount() {
    final promoCode = appliedPromoCode;

    if (promoCode == null) {
      discount = 0;
      return;
    }

    switch (promoCode) {
      case 'SAVE10':
        discount = subtotal * 0.10;
        break;

      case 'GROCERY5':
        if (subtotal >= 30) {
          discount = 5;
        } else {
          appliedPromoCode = null;
          discount = 0;
        }
        break;

      case 'FREEDELIVERY':
        discount = deliveryFee;
        break;

      default:
        appliedPromoCode = null;
        discount = 0;
    }
  }

  void clearCart() {
    _cart.clear();
    appliedPromoCode = null;
    discount = 0;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }
}

class PromoResult {
  const PromoResult({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;
}