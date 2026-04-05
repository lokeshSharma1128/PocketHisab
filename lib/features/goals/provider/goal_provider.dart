import 'package:flutter/foundation.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/budget_model.dart';
import '../../../data/models/goal_model.dart';
import '../../../data/repositories/goal_repository.dart';

class GoalProvider extends ChangeNotifier {
  final GoalRepository _goalRepo;
  final BudgetRepository _budgetRepo;

  GoalProvider(this._goalRepo, this._budgetRepo) {
    _load();
  }

  List<GoalModel> _goals = [];
  List<BudgetModel> _budgets = [];
  bool _isLoading = false;
  String? _error;

  List<GoalModel> get goals => _goals;
  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<GoalModel> get activeGoals =>
      _goals.where((g) => !g.isCompleted).toList();

  List<GoalModel> get completedGoals =>
      _goals.where((g) => g.isCompleted).toList();

  List<BudgetModel> get currentMonthBudgets =>
      _budgetRepo.getForMonth(DateTime.now());

  /// Computes the current no-spend streak from real transaction data.
  ///
  /// A "no-spend day" is any calendar day with zero expense transactions.
  /// We walk backwards from today; the streak breaks the moment we hit a day
  /// that has at least one expense. Today itself is included only if it has
  /// no expenses yet (it is still in progress).
  int computeStreak(List<dynamic> allTransactions) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Build a Set of dates (normalised to midnight) that have expenses
    final spendDays = <DateTime>{};
    for (final t in allTransactions) {
      if (t.type == 'expense') {
        final d = t.date as DateTime;
        spendDays.add(DateTime(d.year, d.month, d.day));
      }
    }

    int streak = 0;
    DateTime cursor = today;

    // Walk backwards day by day until we hit a spend day
    while (true) {
      if (spendDays.contains(cursor)) break; // spend found → streak ends
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));

      // Safety cap: don't go back more than 365 days
      if (streak >= 365) break;
    }

    return streak;
  }

  void _load() {
    _goals = _goalRepo.getAll();
    _budgets = _budgetRepo.getAll();
    notifyListeners();
  }

  Future<void> addGoal({
    required String name,
    required double targetAmount,
    required double savedAmount,
    required DateTime targetDate,
    required String emoji,
    required String color,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _goalRepo.create(
        name: name,
        targetAmount: targetAmount,
        savedAmount: savedAmount,
        targetDate: targetDate,
        emoji: emoji,
        color: color,
      );
      _load();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSavingToGoal(String goalId, double amount) async {
    try {
      await _goalRepo.addSaving(goalId, amount);
      _load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _goalRepo.delete(id);
      _load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addBudget({
    required String category,
    required double limitAmount,
    required String emoji,
  }) async {
    try {
      await _budgetRepo.create(
        category: category,
        limitAmount: limitAmount,
        emoji: emoji,
        month: Formatters.monthKey(DateTime.now()),
      );
      _load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await _budgetRepo.delete(id);
      _load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}