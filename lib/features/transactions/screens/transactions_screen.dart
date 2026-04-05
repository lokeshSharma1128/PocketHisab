import 'package:flutter/material.dart' hide FilterChip;
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/filter_chip.dart';
import '../../../shared/widgets/icon_circle.dart';
import '../provider/transaction_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/transaction_model.dart';
import 'add_transaction_sheet.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    // Group transactions by date label
    final grouped = _groupByDate(provider.filtered);
    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtTertiary = AppColors.textTertiary(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: txtPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      if (provider.searchQuery.isNotEmpty ||
                          provider.categoryFilter.isNotEmpty ||
                          provider.filter != TxnFilter.all)
                        GestureDetector(
                          onTap: provider.clearFilters,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.expense.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.expense,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: TextField(
                controller: _searchController,
                onChanged: provider.setSearch,
                style: TextStyle(color: txtPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: txtTertiary,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            provider.setSearch('');
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: txtTertiary,
                            size: 18,
                          ),
                        )
                      : null,
                ),
              ),
            ),

            // ── Filter Chips ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FilterChip(
                      label: 'All',
                      isActive: provider.filter == TxnFilter.all,
                      onTap: () => provider.setFilter(TxnFilter.all),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: 'Income',
                      isActive: provider.filter == TxnFilter.income,
                      onTap: () => provider.setFilter(TxnFilter.income),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: 'Expense',
                      isActive: provider.filter == TxnFilter.expense,
                      onTap: () => provider.setFilter(TxnFilter.expense),
                    ),
                    const SizedBox(width: 8),
                    ...AppCategories.expenseCategories.take(5).map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: '${cat['emoji']} ${cat['name']}',
                          isActive: provider.categoryFilter == cat['name'],
                          onTap: () => provider.setCategoryFilter(cat['name']!),
                        ),
                      );
                    }),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),

            // ── Transaction List ──
            Expanded(
              child: grouped.isEmpty
                  ? const EmptyState(
                      emoji: '📭',
                      title: 'No transactions found',
                      subtitle:
                          'Try changing your filters or add a new transaction',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      itemCount: grouped.length,
                      itemBuilder: (context, i) {
                        final group = grouped[i];
                        return _DateGroup(
                          label: group['label'] as String,
                          transactions:
                              group['transactions'] as List<TransactionModel>,
                          onDelete: (id) => provider.deleteTransaction(id),
                          onEdit: (t) => _showEdit(context, t),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAdd(context),
        backgroundColor: AppColors.accent,
        foregroundColor: bg,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  List<Map<String, dynamic>> _groupByDate(List<TransactionModel> txns) {
    final Map<String, List<TransactionModel>> map = {};
    for (final t in txns) {
      final label = Formatters.date(t.date);
      map.putIfAbsent(label, () => []).add(t);
    }
    return map.entries
        .map((e) => {'label': e.key, 'transactions': e.value})
        .toList();
  }

  void _showAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionSheet(),
    );
  }

  void _showEdit(BuildContext context, TransactionModel txn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(existing: txn),
    );
  }
}

// ─── Date Group ──────────────────────────────────────────────────────────────
class _DateGroup extends StatelessWidget {
  final String label;
  final List<TransactionModel> transactions;
  final void Function(String) onDelete;
  final void Function(TransactionModel) onEdit;

  const _DateGroup({
    required this.label,
    required this.transactions,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dayTotal = transactions.fold<double>(
      0,
      (sum, t) => t.isIncome ? sum + t.amount : sum - t.amount,
    );

    // Adaptive surface colors from theme

    final txtSecondary = AppColors.textSecondary(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: txtSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${dayTotal >= 0 ? '+' : ''}${Formatters.currency(dayTotal)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: dayTotal >= 0 ? AppColors.income : AppColors.expense,
                ),
              ),
            ],
          ),
        ),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: List.generate(transactions.length, (i) {
              final t = transactions[i];
              return _TxnRow(
                transaction: t,
                showDivider: i < transactions.length - 1,
                onDelete: () => onDelete(t.id),
                onEdit: () => onEdit(t),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Transaction Row ──────────────────────────────────────────────────────────
class _TxnRow extends StatelessWidget {
  final TransactionModel transaction;
  final bool showDivider;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _TxnRow({
    required this.transaction,
    required this.showDivider,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final color = isIncome ? AppColors.income : AppColors.expense;
    final catIndex = AppCategories.expenseCategories.indexWhere(
      (c) => c['name'] == transaction.category,
    );
    final catColor = AppColors.forCategory(catIndex >= 0 ? catIndex : 0);

    // Adaptive surface colors from theme
    final surface = AppColors.surface(context);

    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    final txtTertiary = AppColors.textTertiary(context);

    return Column(
      children: [
        Dismissible(
          key: Key(transaction.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.expense.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.expense,
            ),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Text(
                  'Delete Transaction',
                  style: TextStyle(color: txtPrimary),
                ),
                content: Text(
                  'Are you sure you want to delete this transaction?',
                  style: TextStyle(color: txtSecondary),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: txtSecondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: AppColors.expense),
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => onDelete(),
          child: GestureDetector(
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  IconCircle(emoji: transaction.emoji, color: catColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.notes.isNotEmpty
                              ? transaction.notes
                              : transaction.category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: txtPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          transaction.category,
                          style: TextStyle(fontSize: 12, color: txtSecondary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'}${Formatters.currency(transaction.amount)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.dateShort(transaction.date),
                        style: TextStyle(fontSize: 11, color: txtTertiary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
           Divider(height: 0, color: AppColors.border(context), thickness: 0.5),
      ],
    );
  }
}
