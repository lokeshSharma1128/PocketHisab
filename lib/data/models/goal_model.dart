import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 1)
class GoalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final double savedAmount;

  @HiveField(4)
  final DateTime targetDate;

  @HiveField(5)
  final String emoji;

  @HiveField(6)
  final String color; // hex string

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.targetDate,
    required this.emoji,
    required this.color,
  });

  double get progressPercent =>
      (savedAmount / targetAmount).clamp(0.0, 1.0);

  double get remaining => targetAmount - savedAmount;

  bool get isCompleted => savedAmount >= targetAmount;

  GoalModel copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? savedAmount,
    DateTime? targetDate,
    String? emoji,
    String? color,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      targetDate: targetDate ?? this.targetDate,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
    );
  }
}
