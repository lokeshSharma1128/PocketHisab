import 'package:uuid/uuid.dart';
import '../local/hive_service.dart';
import '../models/transaction_model.dart';
import '../../core/utils/formatters.dart';

class TransactionRepository {
  final _uuid = const Uuid();

  List<TransactionModel> getAll() {
    final box = HiveService.transactionsBox;
    final txns = box.values.toList();
    txns.sort((a, b) => b.date.compareTo(a.date));
    return txns;
  }

  List<TransactionModel> getByMonth(DateTime month) {
    final monthKey = Formatters.monthKey(month);
    return getAll()
        .where((t) => Formatters.monthKey(t.date) == monthKey)
        .toList();
  }

  List<TransactionModel> getByDateRange(DateTime from, DateTime to) {
    return getAll()
        .where((t) => t.date.isAfter(from) && t.date.isBefore(to))
        .toList();
  }

  List<TransactionModel> search(String query) {
    final q = query.toLowerCase();
    return getAll()
        .where((t) =>
            t.category.toLowerCase().contains(q) ||
            t.notes.toLowerCase().contains(q))
        .toList();
  }

  List<TransactionModel> filterByCategory(String category) {
    return getAll().where((t) => t.category == category).toList();
  }

  List<TransactionModel> filterByType(String type) {
    return getAll().where((t) => t.type == type).toList();
  }

  Future<void> add(TransactionModel txn) async {
    final box = HiveService.transactionsBox;
    await box.put(txn.id, txn);
  }

  Future<TransactionModel> create({
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    required String notes,
    required String emoji,
  }) async {
    final txn = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      category: category,
      date: date,
      notes: notes,
      emoji: emoji,
    );
    await add(txn);
    return txn;
  }

  Future<void> update(TransactionModel txn) async {
    final box = HiveService.transactionsBox;
    await box.put(txn.id, txn);
  }

  Future<void> delete(String id) async {
    final box = HiveService.transactionsBox;
    await box.delete(id);
  }

  // Aggregate helpers
  double totalIncome({DateTime? month}) {
    final list = month != null ? getByMonth(month) : getAll();
    return list
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double totalExpenses({DateTime? month}) {
    final list = month != null ? getByMonth(month) : getAll();
    return list
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double balance() => totalIncome() - totalExpenses();

  Map<String, double> expensesByCategory({required DateTime month}) {
    final all = getAll();

    final filtered = all.where((t) =>
    t.isExpense &&
        t.date.year == month.year &&
        t.date.month == month.month);

    final map = <String, double>{};

    for (final txn in filtered) {
      map[txn.category] = (map[txn.category] ?? 0) + txn.amount;
    }

    return map;
  }

  /// Returns daily expenses for the last 7 days
  List<double> weeklyExpenses({required DateTime month}) {
    final all = getAll();

    return List.generate(7, (i) {
      final day = DateTime(month.year, month.month, i + 1);

      return all
          .where((t) =>
      t.isExpense &&
          t.date.year == day.year &&
          t.date.month == day.month &&
          t.date.day == day.day)
          .fold(0.0, (sum, t) => sum + t.amount);
    });
  }
  /// Returns monthly totals for the last N months
  List<Map<String, dynamic>> monthlyTrend({required DateTime baseMonth}) {
    final all = getAll();

    return List.generate(3, (i) {
      final month = DateTime(baseMonth.year, baseMonth.month - (2 - i));

      final expenses = all
          .where((t) =>
      t.isExpense &&
          t.date.year == month.year &&
          t.date.month == month.month)
          .fold(0.0, (sum, t) => sum + t.amount);

      final income = all
          .where((t) =>
      t.isIncome &&
          t.date.year == month.year &&
          t.date.month == month.month)
          .fold(0.0, (sum, t) => sum + t.amount);

      return {
        'month': month,
        'expenses': expenses,
        'income': income,
      };
    });
  }

  Map<String, int> frequentCategories({DateTime? month}) {
    final list = month != null ? getByMonth(month) : getAll();
    final Map<String, int> result = {};
    for (final t in list) {
      result[t.category] = (result[t.category] ?? 0) + 1;
    }
    return result;
  }
}
