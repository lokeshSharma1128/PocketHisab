import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_card.dart';
import 'legend_dot.dart';

class StreakCard extends StatelessWidget {
  final int streakDays;

  /// Raw transactions list used to colour individual day tiles.
  final List<dynamic> transactions;

  const StreakCard({required this.streakDays, required this.transactions});

  // Returns the Set of dates (normalised to midnight) that had expenses.
  Set<DateTime> _buildSpendSet() {
    final set = <DateTime>{};
    for (final t in transactions) {
      if (t.type == 'expense') {
        final d = t.date as DateTime;
        set.add(DateTime(d.year, d.month, d.day));
      }
    }
    return set;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);
    final surface = AppColors.surface(context);
    final surface2 = AppColors.surface2(context);
    final surface3 = AppColors.surface3(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    final txtTertiary = AppColors.textTertiary(context);
    final spendDays = _buildSpendSet();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Build the last 13 days oldest → newest (index 12 = today)
    const totalDays = 13;
    final dayDates = List.generate(
      totalDays,
          (i) => today.subtract(Duration(days: totalDays - 1 - i)),
    );

    // Day-of-week labels (Mon = M … Sun = S)
    const weekLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    String _label(DateTime d) => weekLabels[d.weekday - 1];

    // Motivational footer
    String _footer() {
      if (streakDays == 0) {
        return 'Start today — avoid unnecessary spending! 💪';
      }
      if (streakDays == 1) {
        return 'Great start! Keep going tomorrow 🌱';
      }
      final nextMilestone = (streakDays ~/ 7 + 1) * 7;
      final daysToNext = nextMilestone - streakDays;
      return '$daysToNext more day${daysToNext == 1 ? '' : 's'} to reach a $nextMilestone-day milestone 🏆';
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔥 No-Spend Streak',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: txtPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Based on your actual spending',
                    style: TextStyle(fontSize: 12, color: txtSecondary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$streakDays',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: streakDays > 0 ? AppColors.warning : txtTertiary,
                    ),
                  ),
                  Text(
                    'days',
                    style: TextStyle(fontSize: 11, color: txtSecondary),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Legend ────────────────────────────────────────────────────────
          Row(
            children: [
              LegendDot(color: AppColors.warning, label: 'No spend'),
              const SizedBox(width: 14),
              LegendDot(color: AppColors.expense, label: 'Spent'),
              const SizedBox(width: 14),
              LegendDot(color: surface3, label: 'No data'),
            ],
          ),

          const SizedBox(height: 12),

          // ── 13-day calendar strip ─────────────────────────────────────────
          Row(
            children: dayDates.map((date) {
              final isToday = date == today;
              final hadSpend = spendDays.contains(date);
              // A day counts as "streak day" only if it's within the current
              // unbroken window ending today.
              final daysAgo = today.difference(date).inDays;
              final isStreakDay = !hadSpend && daysAgo < streakDays;

              Color bgColor;
              Color textColor;
              List<BoxShadow>? shadow;
              String icon = '';

              if (hadSpend) {
                bgColor = AppColors.expense.withOpacity(0.18);
                textColor = AppColors.expense;
                icon = '✕';
              } else if (isStreakDay) {
                if (isToday) {
                  bgColor = AppColors.warning;
                  textColor = bg;
                  shadow = [
                    BoxShadow(
                      color: AppColors.warning.withOpacity(0.45),
                      blurRadius: 10,
                    ),
                  ];
                } else {
                  bgColor = AppColors.warning.withOpacity(0.22);
                  textColor = AppColors.warning;
                }
                icon = '✓';
              } else {
                // No expense data and outside current streak window
                bgColor = surface3;
                textColor = txtTertiary;
              }

              return Expanded(
                child: Tooltip(
                  message: _tooltipText(date, hadSpend, isToday),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    height: 46,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(
                        color: hadSpend
                            ? AppColors.expense
                            : AppColors.warning,
                        width: 1.5,
                      )
                          : null,
                      boxShadow: shadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _label(date),
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          icon.isNotEmpty ? icon : '·',
                          style: TextStyle(
                            fontSize: icon.isNotEmpty ? 9 : 14,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 8,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // ── Footer motivational text ──────────────────────────────────────
          Text(
            _footer(),
            style: TextStyle(
              fontSize: 12,
              color: streakDays > 0 ? AppColors.warning : txtSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _tooltipText(DateTime date, bool hadSpend, bool isToday) {
    final label = isToday ? 'Today' : '${date.day}/${date.month}';
    return hadSpend ? '$label: spent money' : '$label: no spend ✓';
  }
}