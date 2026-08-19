import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds app-level state that isn't specific to one feature module:
/// theme mode and whether onboarding has been completed. Member 4 also
/// reads/writes [themeMode] from the settings screen (dark mode toggle).
class AppProvider extends ChangeNotifier {
  static const _kOnboardingSeenKey = 'onboarding_seen';
  static const _kThemeModeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;
  bool _onboardingSeen = false;
  bool _isReady = false;

  ThemeMode get themeMode => _themeMode;
  bool get onboardingSeen => _onboardingSeen;
  bool get isReady => _isReady;

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingSeen = prefs.getBool(_kOnboardingSeenKey) ?? false;
    final storedTheme = prefs.getString(_kThemeModeKey);
    _themeMode = storedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _isReady = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingSeen = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingSeenKey, true);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> toggleDarkMode(bool enabled) => setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
}
