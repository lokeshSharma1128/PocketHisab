import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String type; // 'income' | 'expense'

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String notes;

  @HiveField(6)
  final String emoji;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.notes,
    required this.emoji,
  });

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
    String? notes,
    String? emoji,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      emoji: emoji ?? this.emoji,
    );
  }
}
