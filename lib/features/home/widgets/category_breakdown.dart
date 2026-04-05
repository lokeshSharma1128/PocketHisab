import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

class CategoryBreakdown extends StatelessWidget {
  final Map<String, double> data;

  const CategoryBreakdown({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme

    final surface3 = AppColors.surface3(context);

    final txtSecondary = AppColors.textSecondary(context);
    if (data.isEmpty) {
      return AppCard(
        child: const EmptyState(
          emoji: '🗂️',
          title: 'No expenses yet',
          subtitle: 'Your category breakdown will appear here',
        ),
      );
    }

    final total = data.values.fold(0.0, (a, b) => a + b);
    final entries = data.entries.take(6).toList();

    return AppCard(
      child: Column(
        children: List.generate(entries.length, (i) {
          final e = entries[i];
          final pct = total > 0 ? e.value / total : 0.0;
          final color = AppColors.forCategory(i);
          final emoji = AppCategories.getEmoji(e.key);

          return Padding(
            padding: EdgeInsets.only(bottom: i < entries.length - 1 ? 14 : 0),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: Text(
                    e.key,
                    style: TextStyle(fontSize: 12, color: txtSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: surface3,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 52,
                  child: Text(
                    Formatters.currencyShort(e.value),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: txtSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
