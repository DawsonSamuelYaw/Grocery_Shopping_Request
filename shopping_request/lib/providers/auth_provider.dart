import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Mock authentication for this phase - no backend yet. Accepts any
/// well-formed email/password pair and "logs in" locally, persisting a
/// session flag so the person stays signed in between app launches.
/// Member 4's ProfileProvider can read [userName]/[userEmail] once this
/// is wired to a real backend later.
class AuthProvider extends ChangeNotifier {
  static const _kSessionKey = 'auth_session_active';
  static const _kNameKey = 'auth_user_name';
  static const _kEmailKey = 'auth_user_email';

  AuthStatus _status = AuthStatus.unknown;
  String? _userName;
  String? _userEmail;
  bool _isLoading = false;

  AuthStatus get status => _status;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final active = prefs.getBool(_kSessionKey) ?? false;
    if (active) {
      _userName = prefs.getString(_kNameKey);
      _userEmail = prefs.getString(_kEmailKey);
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<String?> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600)); // simulated network call

    final error = _validateEmail(email) ?? _validatePassword(password);
    if (error != null) {
      _isLoading = false;
      notifyListeners();
      return error;
    }

    await _persistSession(name: email.split('@').first, email: email);
    _isLoading = false;
    _status = AuthStatus.authenticated;
    notifyListeners();
    return null;
  }

  Future<String?> register({required String name, required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));

    if (name.trim().isEmpty) {
      _isLoading = false;
      notifyListeners();
      return 'Enter your full name.';
    }
    final error = _validateEmail(email) ?? _validatePassword(password);
    if (error != null) {
      _isLoading = false;
      notifyListeners();
      return error;
    }

    await _persistSession(name: name.trim(), email: email);
    _isLoading = false;
    _status = AuthStatus.authenticated;
    notifyListeners();
    return null;
  }

  /// Mock "forgot password" flow - just simulates sending a reset email.
  Future<String?> sendPasswordReset({required String email}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    final error = _validateEmail(email);
    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSessionKey, false);
    _userName = null;
    _userEmail = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> _persistSession({required String name, required String email}) async {
    _userName = name;
    _userEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSessionKey, true);
    await prefs.setString(_kNameKey, name);
    await prefs.setString(_kEmailKey, email);
  }

  String? _validateEmail(String value) {
    final trimmed = value.trim();
    final pattern = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (trimmed.isEmpty) return 'Enter your email.';
    if (!pattern.hasMatch(trimmed)) return 'Enter a valid email address.';
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'Enter your password.';
    if (value.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }
}
