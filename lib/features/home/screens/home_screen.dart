import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/section_title.dart';
import '../../transactions/provider/transaction_provider.dart';
import '../provider/app_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../widgets/balance_card.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/category_breakdown.dart';
import '../widgets/recent_transactions_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final txn = context.watch<TransactionProvider>();

    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);
    final surface = AppColors.surface(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          backgroundColor: surface,
          onRefresh: () async {
            // Hive is sync; just trigger rebuild
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: CustomScrollView(
            slivers: [
              // ── Header ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: TextStyle(fontSize: 13, color: txtSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            app.userName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: txtPrimary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => app.setIndex(4),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.accent, AppColors.info],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              app.userName.isNotEmpty
                                  ? app.userName[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: bg,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Balance Card ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: BalanceCard(
                    balance: txn.balance,
                    income: txn.monthlyIncome,
                    expenses: txn.monthlyExpenses,
                    savings: txn.monthlySavings,
                  ),
                ),
              ),

              // ── Weekly Chart ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle('Weekly Spending'),
                      WeeklyChart(data: txn.weeklyExpensesFor(DateTime.now())),
                    ],
                  ),
                ),
              ),

              // ── Category Breakdown ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle('Spending by Category'),
                      CategoryBreakdown(data: txn.expensesByCategory),
                    ],
                  ),
                ),
              ),

              // ── Recent Transactions ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        'Recent Transactions',
                        trailing: GestureDetector(
                          onTap: () => app.setIndex(1),
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      txn.recent.isEmpty
                          ? const EmptyState(
                              emoji: '📭',
                              title: 'No transactions yet',
                              subtitle:
                                  'Add your first transaction to get started',
                            )
                          : RecentTransactionsList(transactions: txn.recent),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}
