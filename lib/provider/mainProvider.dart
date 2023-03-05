import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
