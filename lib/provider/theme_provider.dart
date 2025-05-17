import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themePrefKey = 'isDarkTheme';

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool(_themePrefKey) ?? false;
    notifyListeners();
  }

  void toggleTheme(bool isOn) {
    _isDarkTheme = isOn;
    _saveThemeToPrefs(isOn);
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, value);
  }
}
