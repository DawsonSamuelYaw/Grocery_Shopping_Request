import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/home/placeholder_home_screen.dart';

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
  // Other members: add your module's top-level route here, e.g.
  // static const cart = '/cart';
  // static const orders = '/orders';
  // static const profile = '/profile';
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
      GoRoute(path: AppRoutes.home, builder: (context, state) => const PlaceholderHomeScreen()),
      // Members 2-4: register your feature routes here, e.g.
      // GoRoute(path: AppRoutes.cart, builder: (context, state) => const CartScreen()),
    ],
  );
}
