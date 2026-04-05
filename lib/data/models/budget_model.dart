import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double limitAmount;

  @HiveField(3)
  final String emoji;

  @HiveField(4)
  final String month; // 'YYYY-MM'

  BudgetModel({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.emoji,
    required this.month,
  });

  BudgetModel copyWith({
    String? id,
    String? category,
    double? limitAmount,
    String? emoji,
    String? month,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      emoji: emoji ?? this.emoji,
      month: month ?? this.month,
    );
  }
}
