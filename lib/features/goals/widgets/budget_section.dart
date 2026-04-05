import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/budget_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/progress_bar.dart';

class BudgetSection extends StatelessWidget {
  final List<BudgetModel> budgets;
  final Map<String, double> spentByCategory;
  final void Function(String) onDelete;
  final VoidCallback onAdd;

  const BudgetSection({
    required this.budgets,
    required this.spentByCategory,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme

    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    final txtTertiary = AppColors.textTertiary(context);
    return Column(
      children: [
        ...budgets.map((b) {
          final spent = spentByCategory[b.category] ?? 0;
          final pct = (spent / b.limitAmount).clamp(0.0, 1.0);
          final isOver = spent > b.limitAmount;
          final color = isOver
              ? AppColors.expense
              : pct > 0.8
              ? AppColors.warning
              : AppColors.accent;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(b.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          b.category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: txtPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${Formatters.currency(spent)} / ${Formatters.currency(b.limitAmount)}',
                        style: TextStyle(fontSize: 12, color: txtSecondary),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => onDelete(b.id),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: txtTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PennyProgressBar(
                    progress: pct.toDouble(),
                    color: color,
                    height: 6,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.percent(pct.toDouble()),
                        style: TextStyle(fontSize: 11, color: txtSecondary),
                      ),
                      Text(
                        isOver
                            ? 'Over by ${Formatters.currency(spent - b.limitAmount)}'
                            : '${Formatters.currency(b.limitAmount - spent)} left',
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        // // ── "Add another budget" row ──────────────────────────────────────────
        // GestureDetector(
        //   onTap: onAdd,
        //   child: Container(
        //     width: double.infinity,
        //     padding: const EdgeInsets.symmetric(vertical: 14),
        //     decoration: BoxDecoration(
        //       color: surface3,
        //       borderRadius: BorderRadius.circular(14),
        //       border: const Border.fromBorderSide(
        //         BorderSide(color: Color(0x12FFFFFF), width: 0.5),
        //       ),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: const [
        //         Icon(Icons.add_circle_outline_rounded,
        //             size: 16, color: info),
        //         SizedBox(width: 6),
        //         Text(
        //           'Add another budget',
        //           style: TextStyle(
        //             fontSize: 13,
        //             fontWeight: FontWeight.w500,
        //             color: info,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}