import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> toggleTheme(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);

    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('dark_mode') ?? false;

    _themeMode = isDark
        ? ThemeMode.dark
        : ThemeMode.light;

    notifyListeners();
  }
}