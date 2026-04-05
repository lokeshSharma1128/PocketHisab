import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

class WeeklyChart extends StatelessWidget {
  final List<double> data;

  const WeeklyChart({super.key, required this.data});

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.every((v) => v == 0)) {
      return AppCard(
        child: const EmptyState(
          emoji: '📊',
          title: 'No data yet',
          subtitle: 'Add transactions to see your weekly chart',
        ),
      );
    }

    final maxY = data.reduce((a, b) => a > b ? a : b);
    final today = DateTime.now().weekday - 1; // 0=Mon

    // Adaptive surface colors from theme

    final surface2 = AppColors.surface2(context);
    final surface3 = AppColors.surface3(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtTertiary = AppColors.textTertiary(context);
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY * 1.3,
                minY: 0,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _days[idx].substring(0, 1),
                            style: TextStyle(
                              fontSize: 11,
                              color: idx == today
                                  ? AppColors.accent
                                  : txtTertiary,
                              fontWeight: idx == today
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(data.length, (i) {
                  final isToday = i == today;
                  final isHighest = data[i] == maxY && data[i] > 0;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i] == 0 ? 0.5 : data[i],
                        color: isToday
                            ? AppColors.accent
                            : isHighest
                            ? AppColors.expense.withOpacity(0.8)
                            : surface3,
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => surface2,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        Formatters.currencyShort(rod.toY),
                        TextStyle(
                          color: txtPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
