import 'package:uuid/uuid.dart';
import '../local/hive_service.dart';
import '../models/goal_model.dart';
import '../models/budget_model.dart';
import '../../core/utils/formatters.dart';

class GoalRepository {
  final _uuid = const Uuid();

  List<GoalModel> getAll() {
    return HiveService.goalsBox.values.toList();
  }

  Future<GoalModel> create({
    required String name,
    required double targetAmount,
    required double savedAmount,
    required DateTime targetDate,
    required String emoji,
    required String color,
  }) async {
    final goal = GoalModel(
      id: _uuid.v4(),
      name: name,
      targetAmount: targetAmount,
      savedAmount: savedAmount,
      targetDate: targetDate,
      emoji: emoji,
      color: color,
    );
    await HiveService.goalsBox.put(goal.id, goal);
    return goal;
  }

  Future<void> update(GoalModel goal) async {
    await HiveService.goalsBox.put(goal.id, goal);
  }

  Future<void> addSaving(String goalId, double amount) async {
    final box = HiveService.goalsBox;
    final goal = box.get(goalId);
    if (goal == null) return;
    final updated = goal.copyWith(
      savedAmount: (goal.savedAmount + amount).clamp(0, goal.targetAmount),
    );
    await box.put(goalId, updated);
  }

  Future<void> delete(String id) async {
    await HiveService.goalsBox.delete(id);
  }
}

class BudgetRepository {
  final _uuid = const Uuid();

  List<BudgetModel> getAll() {
    return HiveService.budgetsBox.values.toList();
  }

  List<BudgetModel> getForMonth(DateTime month) {
    final key = Formatters.monthKey(month);
    return getAll().where((b) => b.month == key).toList();
  }

  Future<BudgetModel> create({
    required String category,
    required double limitAmount,
    required String emoji,
    required String month,
  }) async {
    final budget = BudgetModel(
      id: _uuid.v4(),
      category: category,
      limitAmount: limitAmount,
      emoji: emoji,
      month: month,
    );
    await HiveService.budgetsBox.put(budget.id, budget);
    return budget;
  }

  Future<void> update(BudgetModel budget) async {
    await HiveService.budgetsBox.put(budget.id, budget);
  }

  Future<void> delete(String id) async {
    await HiveService.budgetsBox.delete(id);
  }
}
