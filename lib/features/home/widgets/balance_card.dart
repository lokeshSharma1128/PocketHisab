import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  final double savings;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme

    final txtSecondary = AppColors.textSecondary(context);
    final surface = AppColors.surface(context);
    return AppCard(
      color: surface,
      border: Border.all(color: AppColors.accent.withOpacity(0.15), width: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(fontSize: 13, color: txtSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currency(balance),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: AppColors.accent,
              letterSpacing: -1.5,
              fontFamily: 'DMSerifDisplay',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.income.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '↑ This Month',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.income,
              ),
            ),
          ),
           Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.border(context), thickness: 0.5),
          ),
          Row(
            children: [
              _statItem(context, 'Income', income, AppColors.income),
              _divider(),
              _statItem(context, 'Expenses', expenses, AppColors.expense),
              _divider(),
              _statItem(context, 'Saved', savings, AppColors.info),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    final txtSecondary = AppColors.textSecondary(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: txtSecondary)),
          const SizedBox(height: 2),
          Text(
            Formatters.currencyShort(value),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 0.5,
      height: 32,
      color: const Color(0x12FFFFFF),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}
