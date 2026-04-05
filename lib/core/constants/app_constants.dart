import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'PocketHisab';
  static const String transactionsBox = 'transactions';
  static const String goalsBox = 'goals';
  static const String budgetsBox = 'budgets';
  static const String settingsBox = 'settings';

  static const String currencySymbol = '₹';
  static const String defaultUserName = 'User';

  // Hive key for persisted theme preference
  // Stored as int: 0 = system, 1 = light, 2 = dark
  static const String themeModeKey = 'themeMode';
}

class AppCategories {
  static const List<Map<String, String>> expenseCategories = [
    {'name': 'Food', 'emoji': '🍔'},
    {'name': 'Groceries', 'emoji': '🛒'},
    {'name': 'Transport', 'emoji': '🚇'},
    {'name': 'Shopping', 'emoji': '🛍️'},
    {'name': 'Bills', 'emoji': '📱'},
    {'name': 'Health', 'emoji': '🏥'},
    {'name': 'Entertainment', 'emoji': '🎬'},
    {'name': 'Education', 'emoji': '📚'},
    {'name': 'Travel', 'emoji': '✈️'},
    {'name': 'Gym', 'emoji': '🏋️'},
    {'name': 'Rent', 'emoji': '🏠'},
    {'name': 'Others', 'emoji': '💸'},
  ];

  static const List<Map<String, String>> incomeCategories = [
    {'name': 'Salary', 'emoji': '💼'},
    {'name': 'Freelance', 'emoji': '💻'},
    {'name': 'Investment', 'emoji': '📈'},
    {'name': 'Business', 'emoji': '🏪'},
    {'name': 'Gift', 'emoji': '🎁'},
    {'name': 'Others', 'emoji': '💰'},
  ];

  static String getEmoji(String category) {
    final all = [...expenseCategories, ...incomeCategories];
    final found = all.firstWhere(
          (c) => c['name'] == category,
      orElse: () => {'emoji': '💸'},
    );
    return found['emoji'] ?? '💸';
  }
}
