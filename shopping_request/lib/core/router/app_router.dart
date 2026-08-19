// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/categories/category_products_screen.dart';
import '../../features/product/product_details_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/cart/cart_placeholder_screen.dart';
import '../../features/orders/orders_placeholder_screen.dart';
import '../../features/profile/profile_placeholder_screen.dart';

/// Route names, kept as constants so every member references the same
/// strings instead of typing raw paths around the app.
class AppRoutes {
  AppRoutes._();
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const categories = '/categories';
  static const categoryProductsPattern = '/categories/:categoryId';
  static const productDetailsPattern = '/product/:productId';
  static const search = '/search';
  static const cart = '/cart';
  static const orders = '/orders';
  static const profile = '/profile';

  static String categoryProducts(String categoryId) => '/categories/$categoryId';
  static String productDetails(String productId) => '/product/$productId';
  // Members 3-4: add helpers for any parameterised routes you introduce,
  // e.g. static String orderDetails(String orderId) => '/orders/$orderId';
}

/// Builds the app's GoRouter. Member 1 owns this file - please route
/// through here rather than pushing screens directly with Navigator,
/// so redirects (auth guard, onboarding guard) keep working everywhere.
GoRouter buildAppRouter({
  required AppProvider appProvider,
  required AuthProvider authProvider,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: Listenable.merge([appProvider, authProvider]),
    redirect: (context, state) {
      final loc = state.matchedLocation;

      if (!appProvider.isReady || authProvider.status == AuthStatus.unknown) {
        return loc == AppRoutes.splash ? null : AppRoutes.splash;
      }
      if (loc == AppRoutes.splash) {
        if (!appProvider.onboardingSeen) return AppRoutes.onboarding;
        return authProvider.isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }

      final authRoutes = {AppRoutes.login, AppRoutes.register, AppRoutes.forgotPassword};

      if (!appProvider.onboardingSeen && loc != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      if (appProvider.onboardingSeen && loc == AppRoutes.onboarding) {
        return authProvider.isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }
      if (!authProvider.isAuthenticated && !authRoutes.contains(loc) && loc != AppRoutes.onboarding) {
        return AppRoutes.login;
      }
      if (authProvider.isAuthenticated && authRoutes.contains(loc)) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
      GoRoute(path: AppRoutes.categories, builder: (context, state) => const CategoriesScreen()),
      GoRoute(
        path: AppRoutes.categoryProductsPattern,
        builder: (context, state) =>
            CategoryProductsScreen(categoryId: state.pathParameters['categoryId']!),
      ),
      GoRoute(
        path: AppRoutes.productDetailsPattern,
        builder: (context, state) =>
            ProductDetailsScreen(productId: state.pathParameters['productId']!),
      ),
      GoRoute(path: AppRoutes.search, builder: (context, state) => const SearchScreen()),
      GoRoute(path: AppRoutes.cart, builder: (context, state) => const CartPlaceholderScreen()),
      GoRoute(path: AppRoutes.orders, builder: (context, state) => const OrdersPlaceholderScreen()),
      GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfilePlaceholderScreen()),
    ],
  );
}