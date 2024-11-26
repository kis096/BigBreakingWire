import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  Future<ThemeMode> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('darkMode') ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
  }
}
