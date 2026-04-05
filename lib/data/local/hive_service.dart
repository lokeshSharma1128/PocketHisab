import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';
import '../models/budget_model.dart';
import '../../core/constants/app_constants.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(GoalModelAdapter());
    Hive.registerAdapter(BudgetModelAdapter());

    // Open boxes
    await Hive.openBox<TransactionModel>(AppConstants.transactionsBox);
    await Hive.openBox<GoalModel>(AppConstants.goalsBox);
    await Hive.openBox<BudgetModel>(AppConstants.budgetsBox);
    await Hive.openBox(AppConstants.settingsBox);
  }

  static Box<TransactionModel> get transactionsBox =>
      Hive.box<TransactionModel>(AppConstants.transactionsBox);

  static Box<GoalModel> get goalsBox =>
      Hive.box<GoalModel>(AppConstants.goalsBox);

  static Box<BudgetModel> get budgetsBox =>
      Hive.box<BudgetModel>(AppConstants.budgetsBox);

  static Box get settingsBox => Hive.box(AppConstants.settingsBox);

  static Future<void> close() async {
    await Hive.close();
  }
}
