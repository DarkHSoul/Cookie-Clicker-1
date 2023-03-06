import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieProvider with ChangeNotifier, WidgetsBindingObserver {
  var _cookies = 0;
  int get cookies => _cookies;
  set cookies(int value) {
    _cookies = value;
    updateCookies(_cookies);
  }

  void incrementCookie() {
    _cookies++;
    updateCookies(_cookies);
    notifyListeners();
  }

  Future<void> updateCookies(int value) async {
    _cookies = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cookieCount', _cookies);
  }

  static Future<CookieProvider> create() async {
    final provider = CookieProvider();
    await provider.init();
    return provider;
  }

  Future<void> init() async {
    // Load cookie count from shared preferences when the provider is created
    final prefs = await SharedPreferences.getInstance();
    _cookies = prefs.getInt('cookieCount') ?? 0;
    notifyListeners();

    // Add the observer to listen for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer when the provider is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class ThemeProvider with ChangeNotifier {
  static const String _keyDarkMode = 'isDarkMode';
  late SharedPreferences _prefs;
  bool _isDarkMode = false;

  ThemeProvider(SharedPreferences prefs) {
    _prefs = prefs;
    _isDarkMode = _prefs.getBool(_keyDarkMode) ?? false;
  }

  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool(_keyDarkMode, _isDarkMode);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool(_keyDarkMode, _isDarkMode);
    notifyListeners();
  }
}
