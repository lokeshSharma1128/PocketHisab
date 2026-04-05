import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../transactions/provider/transaction_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../widgets/month_tab.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int _selectedMonth = 0; // 0=current
  int touchedIndex = -1;
  Offset? touchPosition;
  DateTime get selectedMonthDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month - _selectedMonth);
  }

  String getMonthLabel(int index) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month - index);

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    // final trend = provider.monthlyTrend;
    // final catData = provider.expensesByCategory;

    // final weeklyData = provider.weeklyExpenses;
    final selectedMonth = selectedMonthDate;

    final trend = provider.monthlyTrendFor(selectedMonth);
    final catData = provider.expensesByCategoryFor(selectedMonth);
    final weeklyData = provider.weeklyExpensesFor(selectedMonth);
    final total = catData.values.fold(0.0, (a, b) => a + b);

    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);

    final surface3 = AppColors.surface3(context);
    final txtPrimary = AppColors.textPrimary(context);

    final txtTertiary = AppColors.textTertiary(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Insights',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: txtPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        MonthTab(
                          label: getMonthLabel(0),
                          isActive: _selectedMonth == 0,
                          onTap: () => setState(() => _selectedMonth = 0),
                        ),
                        const SizedBox(width: 6),
                        MonthTab(
                          label: 'Mar',
                          isActive: _selectedMonth == 1,
                          onTap: () => setState(() => _selectedMonth = 1),
                        ),
                        const SizedBox(width: 6),
                        MonthTab(
                          label: 'Feb',
                          isActive: _selectedMonth == 2,
                          onTap: () => setState(() => _selectedMonth = 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Total Spent',
                        value: Formatters.currencyShort(
                          provider.monthlyExpenses,
                        ),
                        valueColor: AppColors.expense,
                        trend: '8% vs last month',
                        trendUp: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        label: 'Saved',
                        value: Formatters.currencyShort(
                          provider.monthlySavings,
                        ),
                        valueColor: AppColors.income,
                        trend: '18% vs last month',
                        trendUp: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Monthly Trend Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Monthly Trend'),
                    AppCard(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                      child: Column(
                        children: [
                          // Legend
                          Row(
                            children: [
                              _legendItem(AppColors.expense, 'Expenses'),
                              const SizedBox(width: 16),
                              _legendItem(AppColors.income, 'Income'),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 140,
                            child: trend.isEmpty
                                ? Center(
                                    child: Text(
                                      'No data',
                                      style: TextStyle(color: txtTertiary),
                                    ),
                                  )
                                : LineChart(_buildLineChart(trend)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: trend
                                .map(
                                  (m) => Text(
                                    _monthLabel(m['month'] as DateTime),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: txtTertiary,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Donut Chart + Legend
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Spending by Category'),

                    catData.isEmpty
                        ? const EmptyState(
                            emoji: '🗂️',
                            title: 'No expense data',
                            subtitle: 'Add expenses to see category breakdown',
                          )
                        : AppCard(
                            child: Column(
                              children: [
                                _buildCategoryChart(catData, total),
                                const SizedBox(height: 16),
                                ..._buildLegend(catData, total),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),

            // Week vs Last Week
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('This Week vs Last Week'),
                    AppCard(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _legendItem(AppColors.accent, 'This week'),
                              const SizedBox(width: 16),
                              _legendItem(surface3, 'Last week'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 100,
                            child: BarChart(_buildCompareChart(weeklyData)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                                .map(
                                  (d) => Text(
                                    d,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: txtTertiary,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Key Insights
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Key Insights'),
                    ..._buildInsights(provider),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChart(List<Map<String, dynamic>> trend) {
    final expenses = trend.map((m) => m['expenses'] as double).toList();
    final incomes = trend.map((m) => m['income'] as double).toList();
    final allVals = [...expenses, ...incomes];
    final maxY = allVals.isEmpty
        ? 100000.0
        : allVals.reduce((a, b) => a > b ? a : b);

    FlSpot spot(List<double> vals, int i) => FlSpot(i.toDouble(), vals[i]);

    return LineChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(show: false),
      minY: 0,
      maxY: maxY * 1.2,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(expenses.length, (i) => spot(expenses, i)),
          isCurved: true,
          color: AppColors.expense,
          barWidth: 2,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.expense.withOpacity(0.08),
          ),
          dotData: const FlDotData(show: false),
        ),
        LineChartBarData(
          spots: List.generate(incomes.length, (i) => spot(incomes, i)),
          isCurved: true,
          color: AppColors.income,
          barWidth: 2,
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.income.withOpacity(0.06),
          ),
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  // PieChartData _buildPieChart(Map<String, double> data, double total) {
  //   final entries = data.entries.take(7).toList();
  //   return PieChartData(
  //     sectionsSpace: 2,
  //     centerSpaceRadius: 52,
  //     sections: List.generate(entries.length, (i) {
  //       final pct = total > 0 ? entries[i].value / total : 0.0;
  //       return PieChartSectionData(
  //         color: AppColors.forCategory(i),
  //         value: entries[i].value,
  //         title: '',
  //         radius: 36,
  //       );
  //     }),
  //   );
  // }

  PieChartData _buildPieChart(Map<String, double> data, double total) {
    final entries = data.entries.take(7).toList();

    return PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 52,

      pieTouchData: PieTouchData(
        touchCallback: (event, response) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.touchedSection == null) {
              touchedIndex = -1;
              touchPosition = null;
            } else {
              touchedIndex = response.touchedSection!.touchedSectionIndex;

              // 📍 capture tap position
              touchPosition = event.localPosition;
            }
          });
        },
      ),

      sections: List.generate(entries.length, (i) {
        final isTouched = i == touchedIndex;
        final value = entries[i].value;

        return PieChartSectionData(
          color: AppColors.forCategory(i),
          value: value,
          radius: isTouched ? 44 : 36, //  highlight effect
          title: '', //  no text inside
        );
      }),
    );
  }

  List<Widget> _buildLegend(Map<String, double> data, double total) {
    final entries = data.entries.take(6).toList();

    // Adaptive surface colors from theme
    final txtTertiary = AppColors.textTertiary(context);
    final txtSecondary = AppColors.textSecondary(context);

    return List.generate(entries.length, (i) {
      final pct = total > 0 ? entries[i].value / total : 0.0;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.forCategory(i),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                entries[i].key,
                style: TextStyle(fontSize: 13, color: txtSecondary),
              ),
            ),
            Text(
              Formatters.currency(entries[i].value),
              style: TextStyle(
                fontSize: 13,
                color: txtSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Formatters.percent(pct),
              style: TextStyle(fontSize: 11, color: txtTertiary),
            ),
          ],
        ),
      );
    });
  }

  BarChartData _buildCompareChart(List<double> thisWeek) {
    // Mock last week as ~80% of this week for demo
    final lastWeek = thisWeek.map((v) => v * 0.8).toList();
    final maxY = [...thisWeek, ...lastWeek].fold(0.0, (a, b) => a > b ? a : b);

    // Adaptive surface colors from theme
    final surface2 = AppColors.surface2(context);
    final surface3 = AppColors.surface3(context);
    final txtPrimary = AppColors.textPrimary(context);

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY * 1.3,
      minY: 0,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(show: false),
      barGroups: List.generate(7, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: thisWeek[i],
              color: AppColors.accent,
              width: 10,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            BarChartRodData(
              toY: lastWeek[i],
              color: surface3,
              width: 10,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        );
      }),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => surface2,
          getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
            Formatters.currencyShort(rod.toY),
            TextStyle(color: txtPrimary, fontSize: 11),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInsights(TransactionProvider provider) {
    // Adaptive surface colors from theme
    final surface2 = AppColors.surface2(context);

    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    final insights = <Map<String, String>>[];

    final cats = provider.expensesByCategory;
    if (cats.isNotEmpty) {
      final top = cats.entries.first;
      final emoji = AppCategories.getEmoji(top.key);
      insights.add({
        'emoji': emoji,
        'title': 'Highest: ${top.key}',
        'body':
            '${Formatters.currency(top.value)} spent on ${top.key} this month. Consider tracking it closely.',
      });
    }

    final weekly = provider.weeklyExpensesFor(selectedMonthDate);
    final weekdayAvg = weekly.sublist(0, 5).fold(0.0, (a, b) => a + b) / 5;
    final weekendAvg = (weekly[5] + weekly[6]) / 2;
    if (weekdayAvg > 0) {
      final ratio = weekendAvg / weekdayAvg;
      insights.add({
        'emoji': '📅',
        'title': 'Weekends cost ${ratio.toStringAsFixed(1)}× more',
        'body':
            'You spend ${ratio.toStringAsFixed(1)}× more on weekends vs weekdays.',
      });
    }

    final freq = provider.frequentCategories;
    if (freq.isNotEmpty) {
      final topFreq = freq.entries.reduce((a, b) => a.value > b.value ? a : b);
      insights.add({
        'emoji': '💳',
        'title': 'Most frequent: ${topFreq.key}',
        'body': '${topFreq.value} transactions in ${topFreq.key} this month.',
      });
    }

    if (insights.isEmpty) {
      return [
        const EmptyState(
          emoji: '📈',
          title: 'Not enough data',
          subtitle: 'Add more transactions to see insights',
        ),
      ];
    }

    return insights
        .map(
          (ins) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              color: surface2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ins['emoji']!, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ins['title']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: txtPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          ins['body']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: txtSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildCategoryChart(Map<String, double> data, double total) {
    final entries = data.entries.take(7).toList();
    final selected = touchedIndex == -1 ? null : entries[touchedIndex];

    // Adaptive surface colors from theme

    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);

    return Column(
      children: [
        //  Selected info (outside chart)
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 12),
        //   child: Column(
        //     children: [
        //       // Text(
        //       //   selected?.key ?? 'Total',
        //       //   style: const TextStyle(
        //       //     fontSize: 12,
        //       //     color: txtSecondary,
        //       //   ),
        //       // ),
        //       // const SizedBox(height: 4),
        //       Text(
        //         Formatters.currencyShort(
        //             selected?.value ?? total),
        //         style: const TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.w600,
        //           color: txtPrimary,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // 🎯 Pie Chart
        SizedBox(
          height: 200,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              PieChart(_buildPieChart(data, total)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 11, color: txtSecondary),
                  ),
                  Text(
                    Formatters.currencyShort(total),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: txtPrimary,
                    ),
                  ),
                ],
              ),
              //  Tooltip
              if (touchedIndex != -1 && touchPosition != null)
                Positioned(
                  left: touchPosition!.dx - 40,
                  top: touchPosition!.dy - 60,
                  child: _buildTooltip(data),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    // Adaptive surface colors from theme

    final txtSecondary = AppColors.textSecondary(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 11, color: txtSecondary)),
      ],
    );
  }

  Widget _buildTooltip(Map<String, double> data) {
    final entries = data.entries.take(7).toList();
    final item = entries[touchedIndex];

    // Adaptive surface colors from theme

    final surface2 = AppColors.surface2(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x12FFFFFF)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.key, style: TextStyle(fontSize: 11, color: txtSecondary)),
            const SizedBox(height: 2),
            Text(
              Formatters.currencyShort(item.value),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: txtPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthLabel(DateTime dt) {
    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    return months[dt.month - 1];
  }
}
