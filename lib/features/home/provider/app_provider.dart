import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/local/hive_service.dart';

class AppProvider extends ChangeNotifier {
  int _currentIndex = 0;

  // ThemeMode is loaded from Hive on construction.
  // Default = ThemeMode.system (follows device setting).
  late ThemeMode _themeMode;

  AppProvider() {
    _themeMode = _loadThemeMode();
  }

  // ── Getters ──────────────────────────────────────────────────────────────

  int get currentIndex => _currentIndex;

  ThemeMode get themeMode => _themeMode;

  /// true  → dark is explicitly ON
  /// false → dark is explicitly OFF
  /// null  → following system (no explicit override)
  bool? get isDarkModeOn {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    return null; // system
  }

  bool get followsSystem => _themeMode == ThemeMode.system;

  String get userName =>
      HiveService.settingsBox.get('userName', defaultValue: 'User') as String;

  // ── Navigation ────────────────────────────────────────────────────────────

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ── Theme ─────────────────────────────────────────────────────────────────

  /// Called from the dark-mode toggle in Settings.
  /// [on] true  → force dark
  /// [on] false → force light
  Future<void> setDarkMode(bool on) async {
    // If already manually set, toggle between light/dark
    if (_themeMode == ThemeMode.dark && on == false) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light && on == true) {
      _themeMode = ThemeMode.dark;
    } else {
      // First interaction → override system
      _themeMode = on ? ThemeMode.dark : ThemeMode.light;
    }

    await _saveThemeMode(_themeMode);
    notifyListeners();
  }

  /// Called when "Use device theme" is toggled in Settings.
  // Future<void> setFollowSystem(bool follow) async {
  //   if (follow) {
  //     _themeMode = ThemeMode.system;
  //   } else {
  //     // When user opts out of system, default to dark
  //     _themeMode = ThemeMode.dark;
  //   }
  //   await _saveThemeMode(_themeMode);
  //   notifyListeners();
  // }

  // ── User ──────────────────────────────────────────────────────────────────

  Future<void> setUserName(String name) async {
    await HiveService.settingsBox.put('userName', name);
    notifyListeners();
  }

  // ── Hive persistence ──────────────────────────────────────────────────────

  // Stored as int: 0 = system, 1 = light, 2 = dark
  ThemeMode _loadThemeMode() {
    final stored = HiveService.settingsBox.get(AppConstants.themeModeKey);

    // If nothing saved → follow system
    if (stored == null) {
      return ThemeMode.system;
    }

    switch (stored as int) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    int val;
    switch (mode) {
      case ThemeMode.light:
        val = 1;
        break;
      case ThemeMode.dark:
        val = 2;
        break;
      case ThemeMode.system:
      default:
        val = 0; //
    }
    await HiveService.settingsBox.put(AppConstants.themeModeKey, val);
  }
}