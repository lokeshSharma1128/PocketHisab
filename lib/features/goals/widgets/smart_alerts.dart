import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/budget_model.dart';
import '../../../shared/widgets/app_card.dart';

class SmartAlerts extends StatelessWidget {
  final List<BudgetModel> budgets;
  final Map<String, double> spentByCategory;

  const SmartAlerts({required this.budgets, required this.spentByCategory});

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme

    final surface2 = AppColors.surface2(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    if (budgets.isEmpty) {
      return AppCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Add budgets above to see smart alerts here.',
              style: TextStyle(fontSize: 13, color: txtSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final alerts = <Map<String, dynamic>>[];
    for (final b in budgets) {
      final spent = spentByCategory[b.category] ?? 0;
      final pct = spent / b.limitAmount;

      if (pct >= 1.0) {
        alerts.add({
          'emoji': '🚨',
          'title': '${b.category} budget exceeded',
          'subtitle':
          '${Formatters.currency(spent)} of ${Formatters.currency(b.limitAmount)} limit used',
        });
      } else if (pct >= 0.8) {
        alerts.add({
          'emoji': '⚠️',
          'title': '${b.category} budget is high',
          'subtitle':
          '${Formatters.percent(pct)} of your limit used this month',
        });
      } else {
        alerts.add({
          'emoji': '✅',
          'title': '${b.category} on track',
          'subtitle':
          '${Formatters.currency(b.limitAmount - spent)} remaining — great control!',
        });
      }
    }

    return Column(
      children: alerts.map((a) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: AppCard(
            color: surface2,
            child: Row(
              children: [
                Text(
                  a['emoji'] as String,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['title'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: txtPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        a['subtitle'] as String,
                        style: TextStyle(fontSize: 12, color: txtSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}