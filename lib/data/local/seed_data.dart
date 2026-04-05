import 'package:uuid/uuid.dart';
import '../local/hive_service.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';
import '../models/budget_model.dart';
import '../../core/utils/formatters.dart';

class SeedDataService {
  static const _uuid = Uuid();

  static Future<void> seedIfEmpty() async {
    final txnBox = HiveService.transactionsBox;
    if (txnBox.isNotEmpty) return;

    final now = DateTime.now();

    // Seed transactions
    final transactions = [
      _txn('Salary', 85000, 'income', 'Salary', '💼',
          now.subtract(const Duration(days: 2))),
      _txn('Swiggy Order', 420, 'expense', 'Food', '🍔',
          now.subtract(const Duration(days: 0))),
      _txn('BigBasket', 1850, 'expense', 'Groceries', '🛒',
          now.subtract(const Duration(days: 0))),
      _txn('Metro Card', 500, 'expense', 'Transport', '🚇',
          now.subtract(const Duration(days: 1))),
      _txn('Jio Recharge', 719, 'expense', 'Bills', '📱',
          now.subtract(const Duration(days: 2))),
      _txn('Netflix', 649, 'expense', 'Entertainment', '🎬',
          now.subtract(const Duration(days: 2))),
      _txn('Zomato', 380, 'expense', 'Food', '🍕',
          now.subtract(const Duration(days: 3))),
      _txn('Gym Membership', 2000, 'expense', 'Health', '🏋️',
          now.subtract(const Duration(days: 3))),
      _txn('Freelance Payment', 25000, 'income', 'Freelance', '💻',
          now.subtract(const Duration(days: 4))),
      _txn('Myntra', 2200, 'expense', 'Shopping', '👕',
          now.subtract(const Duration(days: 4))),
      _txn('Electricity Bill', 1840, 'expense', 'Bills', '⚡',
          now.subtract(const Duration(days: 5))),
      _txn('Uber Ride', 340, 'expense', 'Transport', '🚗',
          now.subtract(const Duration(days: 5))),
      _txn('Amazon', 3200, 'expense', 'Shopping', '📦',
          now.subtract(const Duration(days: 6))),
      _txn('Restaurant', 1800, 'expense', 'Food', '🍽️',
          now.subtract(const Duration(days: 7))),
      _txn('Medical', 650, 'expense', 'Health', '💊',
          now.subtract(const Duration(days: 8))),
      _txn('Stationery', 420, 'expense', 'Education', '📚',
          now.subtract(const Duration(days: 10))),
      _txn('Investment Return', 5000, 'income', 'Investment', '📈',
          now.subtract(const Duration(days: 12))),
      _txn('Coffee Shop', 280, 'expense', 'Food', '☕',
          now.subtract(const Duration(days: 13))),
    ];

    for (final t in transactions) {
      await txnBox.put(t.id, t);
    }

    // Seed goals
    final goalsBox = HiveService.goalsBox;
    final goals = [
      GoalModel(
        id: _uuid.v4(),
        name: 'Europe Trip',
        targetAmount: 120000,
        savedAmount: 68000,
        targetDate: DateTime(now.year + 1, 12, 31),
        emoji: '✈️',
        color: '0xFF60A5FA',
      ),
      GoalModel(
        id: _uuid.v4(),
        name: 'Emergency Fund',
        targetAmount: 75000,
        savedAmount: 45000,
        targetDate: DateTime(now.year + 1, 6, 30),
        emoji: '🛡️',
        color: '0xFFA78BFA',
      ),
      GoalModel(
        id: _uuid.v4(),
        name: 'New Laptop',
        targetAmount: 90000,
        savedAmount: 22000,
        targetDate: DateTime(now.year, now.month + 4, 1),
        emoji: '💻',
        color: '0xFF6EE7B7',
      ),
    ];

    for (final g in goals) {
      await goalsBox.put(g.id, g);
    }

    // Seed budgets
    final budgetsBox = HiveService.budgetsBox;
    final monthKey = Formatters.monthKey(now);
    final budgets = [
      BudgetModel(
          id: _uuid.v4(), category: 'Food', limitAmount: 8000, emoji: '🍔', month: monthKey),
      BudgetModel(
          id: _uuid.v4(), category: 'Transport', limitAmount: 5000, emoji: '🚇', month: monthKey),
      BudgetModel(
          id: _uuid.v4(), category: 'Entertainment', limitAmount: 4000, emoji: '🎬', month: monthKey),
      BudgetModel(
          id: _uuid.v4(), category: 'Shopping', limitAmount: 10000, emoji: '🛍️', month: monthKey),
    ];

    for (final b in budgets) {
      await budgetsBox.put(b.id, b);
    }

    // Seed settings
    HiveService.settingsBox.put('userName', 'Aryan');
    HiveService.settingsBox.put('streakDays', 12);
  }

  static TransactionModel _txn(
    String category,
    double amount,
    String type,
    String catName,
    String emoji,
    DateTime date,
  ) {
    return TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      category: catName,
      date: date,
      notes: '',
      emoji: emoji,
    );
  }
}
