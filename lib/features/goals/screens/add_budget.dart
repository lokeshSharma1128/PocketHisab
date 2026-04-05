import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../provider/goal_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

class AddBudgetSheet extends StatefulWidget {
  const AddBudgetSheet({super.key});

  @override
  State<AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends State<AddBudgetSheet> {
  final _limitCtrl = TextEditingController();
  String _category = '';
  String _emoji = '';
  bool _isSaving = false;

  // All spendable categories with their emoji
  final _categories = AppCategories.expenseCategories;

  @override
  void initState() {
    super.initState();
    if (_categories.isNotEmpty) {
      _category = _categories.first['name']!;
      _emoji = _categories.first['emoji']!;
    }
  }

  @override
  void dispose() {
    _limitCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final limit = double.tryParse(_limitCtrl.text.trim()) ?? 0;

    if (_category.isEmpty) {
      _showError('Please select a category.');
      return;
    }
    if (limit <= 0) {
      _showError('Please enter a valid limit amount.');
      return;
    }

    // Check if budget for this category already exists this month
    final provider = context.read<GoalProvider>();
    final existing = provider.currentMonthBudgets.any(
      (b) => b.category == _category,
    );
    if (existing) {
      _showError('A budget for $_category already exists this month.');
      return;
    }

    setState(() => _isSaving = true);
    await provider.addBudget(
      category: _category,
      limitAmount: limit,
      emoji: _emoji,
    );
    setState(() => _isSaving = false);

    if (mounted) Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);
    final surface = AppColors.surface(context);
    final surface3 = AppColors.surface3(context);
    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    final txtTertiary = AppColors.textTertiary(context);
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: surface3,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Set Monthly Budget',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: txtPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: surface3,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: txtSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                Formatters.monthYear(DateTime.now()),
                style: TextStyle(fontSize: 12, color: txtSecondary),
              ),
              const SizedBox(height: 22),

              // Category label
              Text(
                'CATEGORY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: txtSecondary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),

              // Category grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final isSelected = _category == cat['name'];
                  return GestureDetector(
                    onTap: () => setState(() {
                      _category = cat['name']!;
                      _emoji = cat['emoji']!;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent.withOpacity(0.14)
                            : surface3,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : const Color(0x12FFFFFF),
                          width: isSelected ? 1 : 0.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cat['emoji']!,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat['name']!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.accent
                                  : txtSecondary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Monthly limit input
              Text(
                'MONTHLY LIMIT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: txtSecondary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),

              // Large styled amount input
              Container(
                decoration: BoxDecoration(
                  color: surface3,
                  borderRadius: BorderRadius.circular(14),
                  border: const Border.fromBorderSide(
                    BorderSide(color: Color(0x12FFFFFF), width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppConstants.currencySymbol,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _limitCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: txtPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    if (_limitCtrl.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _limitCtrl.clear();
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 14),
                          child: Icon(
                            Icons.cancel_rounded,
                            size: 18,
                            color: txtTertiary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Quick amount chips
              Row(
                children: [5000, 10000, 15000, 20000].map((amount) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        _limitCtrl.text = amount.toString();
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: surface3,
                          borderRadius: BorderRadius.circular(20),
                          border: const Border.fromBorderSide(
                            BorderSide(color: Color(0x12FFFFFF), width: 0.5),
                          ),
                        ),
                        child: Text(
                          Formatters.currencyShort(amount.toDouble()),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: txtSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              // Preview card — shown when both fields are filled
              if (_category.isNotEmpty &&
                  (double.tryParse(_limitCtrl.text) ?? 0) > 0) ...[
                _BudgetPreview(
                  emoji: _emoji,
                  category: _category,
                  limit: double.tryParse(_limitCtrl.text) ?? 0,
                ),
                const SizedBox(height: 16),
              ],

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: bg,
                          ),
                        )
                      : const Text('Set Budget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Budget Preview ───────────────────────────────────────────────────────────
class _BudgetPreview extends StatelessWidget {
  final String emoji;
  final String category;
  final double limit;

  const _BudgetPreview({
    required this.emoji,
    required this.category,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final daily = limit / 30;

    // Adaptive surface colors from theme

    final txtPrimary = AppColors.textPrimary(context);
    final txtSecondary = AppColors.textSecondary(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: txtPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '≈ ${Formatters.currency(daily)} per day',
                  style: TextStyle(fontSize: 11, color: txtSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(limit),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
              Text(
                'per month',
                style: TextStyle(fontSize: 10, color: txtSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
