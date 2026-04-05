import 'package:flutter/foundation.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../core/constants/app_constants.dart';

enum TxnFilter { all, income, expense }

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repo;

  TransactionProvider(this._repo) {
    _load();
  }

  List<TransactionModel> _all = [];
  TxnFilter _filter = TxnFilter.all;
  String _searchQuery = '';
  String _categoryFilter = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  TxnFilter get filter => _filter;
  String get searchQuery => _searchQuery;
  String get categoryFilter => _categoryFilter;

  List<TransactionModel> get all => _all;

  List<TransactionModel> get filtered {
    var list = _all;

    if (_filter == TxnFilter.income) {
      list = list.where((t) => t.isIncome).toList();
    } else if (_filter == TxnFilter.expense) {
      list = list.where((t) => t.isExpense).toList();
    }

    if (_categoryFilter.isNotEmpty) {
      list = list.where((t) => t.category == _categoryFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((t) =>
              t.category.toLowerCase().contains(q) ||
              t.notes.toLowerCase().contains(q))
          .toList();
    }

    return list;
  }

  List<TransactionModel> get recent => _all.take(5).toList();

  // Aggregates for current month
  double get monthlyIncome =>
      _repo.totalIncome(month: DateTime.now());

  double get monthlyExpenses =>
      _repo.totalExpenses(month: DateTime.now());

  double get balance => _repo.balance();

  double get monthlySavings => monthlyIncome - monthlyExpenses;

  Map<String, double> get expensesByCategory =>
      _repo.expensesByCategory(month: DateTime.now());



  Map<String, double> expensesByCategoryFor(DateTime month) {
    return _repo.expensesByCategory(month: month);
  }

  List<double> weeklyExpensesFor(DateTime month) {
    return _repo.weeklyExpenses(month: month);
  }

  List<Map<String, dynamic>> monthlyTrendFor(DateTime month) {
    return _repo.monthlyTrend(baseMonth: month);
  }

  Map<String, int> get frequentCategories =>
      _repo.frequentCategories(month: DateTime.now());



  String get topCategory {
    final cats = expensesByCategory;
    if (cats.isEmpty) return 'N/A';
    return cats.entries.first.key;
  }

  // Methods
  void _load() {
    _all = _repo.getAll();
    notifyListeners();
  }

  void setFilter(TxnFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _categoryFilter = _categoryFilter == category ? '' : category;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _filter = TxnFilter.all;
    _categoryFilter = '';
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> addTransaction({
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    required String notes,
    required String emoji,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.create(
        amount: amount,
        type: type,
        category: category,
        date: date,
        notes: notes,
        emoji: emoji,
      );
      _load();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(TransactionModel txn) async {
    try {
      await _repo.update(txn);
      _load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _repo.delete(id);
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
