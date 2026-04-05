import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/transaction_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/icon_circle.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const RecentTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Column(
        children: List.generate(transactions.length, (i) {
          final t = transactions[i];
          return _TransactionTile(
            transaction: t,
            showDivider: i < transactions.length - 1,
          );
        }),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final bool showDivider;

  const _TransactionTile({
    required this.transaction,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final color = isIncome ? AppColors.income : AppColors.expense;
    final catIndex = AppCategories.expenseCategories
        .indexWhere((c) => c['name'] == transaction.category);
    final colorForCat = AppColors.forCategory(catIndex >= 0 ? catIndex : 0);


    // Adaptive surface colors from theme

    final txtPrimary    = AppColors.textPrimary(context);
    final txtSecondary  = AppColors.textSecondary(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              IconCircle(emoji: transaction.emoji, color: colorForCat),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.notes.isNotEmpty
                          ? transaction.notes
                          : transaction.category,
                      style:  TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: txtPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${transaction.category} · ${Formatters.date(transaction.date)}',
                      style:  TextStyle(
                        fontSize: 11,
                        color: txtSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'}${Formatters.currency(transaction.amount)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
           Divider(height: 0, color:AppColors.border(context), thickness: 0.5),
      ],
    );
  }
}
