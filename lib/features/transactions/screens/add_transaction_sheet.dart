import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../provider/transaction_provider.dart';
import '../../../data/models/transaction_model.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';

class AddTransactionSheet extends StatefulWidget {
  final TransactionModel? existing;

  const AddTransactionSheet({super.key, this.existing});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  String _type = 'expense';
  String _category = '';
  String _emoji = '💸';
  String _amountStr = '0';
  String _notes = '';
  DateTime _date = DateTime.now();
  final _notesController = TextEditingController();

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.existing!;
      _type = t.type;
      _category = t.category;
      _emoji = t.emoji;
      _amountStr = t.amount.toStringAsFixed(0);
      _notes = t.notes;
      _date = t.date;
      _notesController.text = t.notes;
    } else {
      final cats = _currentCategories;
      if (cats.isNotEmpty) {
        _category = cats.first['name']!;
        _emoji = cats.first['emoji']!;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _currentCategories => _type == 'expense'
      ? AppCategories.expenseCategories
      : AppCategories.incomeCategories;

  void _onTypeChange(String type) {
    setState(() {
      _type = type;
      final cats = _currentCategories;
      if (cats.isNotEmpty) {
        _category = cats.first['name']!;
        _emoji = cats.first['emoji']!;
      }
    });
  }

  void _keypadPress(String key) {
    setState(() {
      if (key == '⌫') {
        _amountStr = _amountStr.length > 1
            ? _amountStr.substring(0, _amountStr.length - 1)
            : '0';
      } else if (key == '.' && !_amountStr.contains('.')) {
        _amountStr += '.';
      } else if (key != '.' && _amountStr != '0') {
        if (_amountStr.contains('.')) {
          final parts = _amountStr.split('.');
          if (parts[1].length < 2) _amountStr += key;
        } else {
          _amountStr += key;
        }
      } else if (key != '.') {
        _amountStr = key;
      }
    });
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountStr) ?? 0;
    if (amount <= 0 || _category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount and category'),
        ),
      );
      return;
    }

    final provider = context.read<TransactionProvider>();

    if (_isEditing) {
      await provider.updateTransaction(
        widget.existing!.copyWith(
          amount: amount,
          type: _type,
          category: _category,
          date: _date,
          notes: _notesController.text,
          emoji: _emoji,
        ),
      );
    } else {
      await provider.addTransaction(
        amount: amount,
        type: _type,
        category: _category,
        date: _date,
        notes: _notesController.text,
        emoji: _emoji,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);
    final surface2 = AppColors.surface2(context);
    final txtPrimary = AppColors.textPrimary(context);

    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.accent,
            onPrimary: bg,
            surface: surface2,
            onSurface: txtPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amountStr) ?? 0;
    final isLoading = context.watch<TransactionProvider>().isLoading;

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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
              const SizedBox(height: 16),

              // Title + Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Edit Transaction' : 'Add Transaction',
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
                        color: txtSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Amount display
              Center(
                child: Text(
                  '${AppConstants.currencySymbol}${amount == 0 ? '0' : amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    color: _type == 'income'
                        ? AppColors.income
                        : AppColors.expense,
                    letterSpacing: -2,
                    fontFamily: 'DMSerifDisplay',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Type toggle
              Container(
                decoration: BoxDecoration(
                  color: surface3,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _typeBtn('expense', 'Expense', AppColors.expense),
                    const SizedBox(width: 4),
                    _typeBtn('income', 'Income', AppColors.income),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Category
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 12,
                  color: txtSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _currentCategories.map((cat) {
                    final isSelected = _category == cat['name'];
                    return GestureDetector(
                      onTap: () => setState(() {
                        _category = cat['name']!;
                        _emoji = cat['emoji']!;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withOpacity(0.15)
                              : surface3,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : const Color(0x12FFFFFF),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '${cat['emoji']} ${cat['name']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? AppColors.accent : txtSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Date + Notes row
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: surface3,
                          borderRadius: BorderRadius.circular(12),
                          border: const Border.fromBorderSide(
                            BorderSide(color: Color(0x12FFFFFF), width: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 15,
                              color: txtSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              Formatters.dateShort(_date),
                              style: TextStyle(fontSize: 13, color: txtPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Notes
              TextField(
                controller: _notesController,
                style: TextStyle(color: txtPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Add a note...',
                  prefixIcon: Icon(
                    Icons.edit_note_rounded,
                    color: txtTertiary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Keypad
              _buildKeypad(),
              const SizedBox(height: 16),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: bg,
                          ),
                        )
                      : Text(
                          _isEditing
                              ? 'Update Transaction'
                              : 'Save Transaction',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeBtn(String type, String label, Color color) {
    final isActive = _type == type;

    // Adaptive surface colors from theme

    final txtTertiary = AppColors.textTertiary(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTypeChange(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive ? color : txtTertiary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];
    // Adaptive surface colors from theme
    final surface3 = AppColors.surface3(context);
    final txtPrimary = AppColors.textPrimary(context);
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: keys.map((key) {
        return GestureDetector(
          onTap: () => _keypadPress(key),
          child: Container(
            decoration: BoxDecoration(
              color: key == '⌫' ? AppColors.expense.withOpacity(0.1) : surface3,
              borderRadius: BorderRadius.circular(12),
              border: const Border.fromBorderSide(
                BorderSide(color: Color(0x12FFFFFF), width: 0.5),
              ),
            ),
            child: Center(
              child: Text(
                key,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: key == '⌫' ? AppColors.expense : txtPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
