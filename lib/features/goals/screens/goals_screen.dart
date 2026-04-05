import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/section_title.dart';
import '../provider/goal_provider.dart';
import '../../transactions/provider/transaction_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/goal_model.dart';
import '../../../data/models/budget_model.dart';
import '../widgets/budget_section.dart';
import '../widgets/goal_card.dart';
import '../widgets/smart_alerts.dart';
import '../widgets/streak_card.dart';
import 'add_budget.dart';
import 'add_goal_sheet.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GoalProvider>();
    final txnProvider = context.watch<TransactionProvider>();
    // Streak is computed live from actual transaction history
    final streak = provider.computeStreak(txnProvider.all);

    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);

    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────────
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
                          'Goals & Challenges',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: txtPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Build better money habits',
                          style: TextStyle(fontSize: 13, color: txtSecondary),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        '${provider.activeGoals.length} active',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── No-Spend Streak ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('No-Spend Streak'),
                    StreakCard(
                      streakDays: streak,
                      transactions: txnProvider.all,
                    ),
                  ],
                ),
              ),
            ),

            // ── Savings Goals header ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: SectionTitle(
                  'Savings Goals',
                  trailing: GestureDetector(
                    onTap: () => _showAddGoal(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '+ Add Goal',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Goals list or empty state ─────────────────────────────────────
            provider.activeGoals.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: EmptyState(
                        emoji: '🎯',
                        title: 'No goals yet',
                        subtitle: 'Set a savings goal to stay motivated',
                        action: ElevatedButton(
                          onPressed: () => _showAddGoal(context),
                          child: const Text('Create Goal'),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: GoalCard(
                          goal: provider.activeGoals[i],
                          onDelete: () =>
                              provider.deleteGoal(provider.activeGoals[i].id),
                          onAddSaving: (amount) => provider.addSavingToGoal(
                            provider.activeGoals[i].id,
                            amount,
                          ),
                        ),
                      );
                    }, childCount: provider.activeGoals.length),
                  ),

            // ── Monthly Budgets header (with Add Budget button) ───────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: SectionTitle(
                  'Monthly Budgets',
                  trailing: GestureDetector(
                    onTap: () => _showAddBudget(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '+ Add Budget',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Budget cards or empty state ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: provider.currentMonthBudgets.isEmpty
                    ? _BudgetEmptyState(onAdd: () => _showAddBudget(context))
                    : BudgetSection(
                        budgets: provider.currentMonthBudgets,
                        spentByCategory: txnProvider.expensesByCategory,
                        onDelete: provider.deleteBudget,
                        onAdd: () => _showAddBudget(context),
                      ),
              ),
            ),

            // ── Smart Alerts ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Smart Alerts'),
                    SmartAlerts(
                      budgets: provider.currentMonthBudgets,
                      spentByCategory: txnProvider.expensesByCategory,
                    ),
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

  void _showAddGoal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddGoalSheet(),
    );
  }

  void _showAddBudget(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddBudgetSheet(),
    );
  }
}

// ─── Budget Empty State ───────────────────────────────────────────────────────
class _BudgetEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _BudgetEmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme

    final surface2 = AppColors.surface2(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    return AppCard(
      color: surface2,
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text('💰', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'No budgets set',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: txtPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Set monthly limits to keep your\nspending under control.',
            style: TextStyle(fontSize: 13, color: txtSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: const Text(
                '+ Set First Budget',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.info,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

