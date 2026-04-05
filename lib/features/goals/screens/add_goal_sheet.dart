import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../provider/goal_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

class AddGoalSheet extends StatefulWidget {
   AddGoalSheet({super.key});

  @override
  State<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<AddGoalSheet> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _savedCtrl = TextEditingController();
  DateTime _targetDate = DateTime.now().add( Duration(days: 180));
  String _emoji = '🎯';
  String _color = '0xFF6EE7B7';

  final _emojiOptions = ['🎯', '✈️', '🏠', '🛡️', '💻', '🚗', '💍', '📱', '🎓', '🌴'];
  final _colorOptions = [
    {'hex': '0xFF6EE7B7', 'color': AppColors.accent},
    {'hex': '0xFF60A5FA', 'color': AppColors.info},
    {'hex': '0xFFA78BFA', 'color': AppColors.purple},
    {'hex': '0xFFF87171', 'color': AppColors.expense},
    {'hex': '0xFFFBBF24', 'color': AppColors.warning},
    {'hex': '0xFFF472B6', 'color':  Color(0xFFF472B6)},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    _savedCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _targetCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final target = double.tryParse(_targetCtrl.text) ?? 0;
    final saved = double.tryParse(_savedCtrl.text) ?? 0;

    if (target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Enter a valid target amount')),
      );
      return;
    }

    await context.read<GoalProvider>().addGoal(
          name: _nameCtrl.text.trim(),
          targetAmount: target,
          savedAmount: saved,
          targetDate: _targetDate,
          emoji: _emoji,
          color: _color,
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {


    // Adaptive surface colors from theme
    final bg        = AppColors.bg(context);
    final surface   = AppColors.surface(context);
    final surface2  = AppColors.surface2(context);
    final surface3  = AppColors.surface3(context);
    final txtPrimary    = AppColors.textPrimary(context);
    final txtSecondary  = AppColors.textSecondary(context);
    return Container(
      decoration:  BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: surface3,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
               SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('New Goal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: txtPrimary)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child:  Icon(Icons.close_rounded, color: txtSecondary),
                  ),
                ],
              ),
               SizedBox(height: 20),

              // Emoji selector
               Text('Icon', style: TextStyle(fontSize: 12, color: txtSecondary)),
               SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _emojiOptions.map((e) {
                    final isSelected = _emoji == e;
                    return GestureDetector(
                      onTap: () => setState(() => _emoji = e),
                      child: AnimatedContainer(
                        duration:  Duration(milliseconds: 150),
                        margin:  EdgeInsets.only(right: 8),
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accent.withOpacity(0.15) : surface3,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.accent :  Color(0x12FFFFFF),
                            width: 0.5,
                          ),
                        ),
                        child: Center(child: Text(e, style:  TextStyle(fontSize: 22))),
                      ),
                    );
                  }).toList(),
                ),
              ),
               SizedBox(height: 14),

              // Color
               Text('Color', style: TextStyle(fontSize: 12, color: txtSecondary)),
               SizedBox(height: 8),
              Row(
                children: _colorOptions.map((opt) {
                  final isSelected = _color == opt['hex'] as String;
                  final col = opt['color'] as Color;
                  return GestureDetector(
                    onTap: () => setState(() => _color = opt['hex'] as String),
                    child: Container(
                      margin:  EdgeInsets.only(right: 10),
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: col,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: txtPrimary, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
               SizedBox(height: 14),

              // Name
               Text('Goal Name *', style: TextStyle(fontSize: 12, color: txtSecondary)),
               SizedBox(height: 6),
              TextField(
                controller: _nameCtrl,
                style:  TextStyle(color: txtPrimary, fontSize: 14),
                decoration:  InputDecoration(hintText: 'e.g. Europe Trip, Emergency Fund'),
              ),
               SizedBox(height: 10),

              // Amounts
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Target Amount *', style: TextStyle(fontSize: 12, color: txtSecondary)),
                         SizedBox(height: 6),
                        TextField(
                          controller: _targetCtrl,
                          keyboardType: TextInputType.number,
                          style:  TextStyle(color: txtPrimary, fontSize: 14),
                          decoration:  InputDecoration(
                            hintText: '0',
                            prefixText: '₹ ',
                            prefixStyle: TextStyle(color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Already Saved', style: TextStyle(fontSize: 12, color: txtSecondary)),
                         SizedBox(height: 6),
                        TextField(
                          controller: _savedCtrl,
                          keyboardType: TextInputType.number,
                          style:  TextStyle(color: txtPrimary, fontSize: 14),
                          decoration:  InputDecoration(
                            hintText: '0',
                            prefixText: '₹ ',
                            prefixStyle: TextStyle(color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
               SizedBox(height: 10),

              // Target Date
               Text('Target Date *', style: TextStyle(fontSize: 12, color: txtSecondary)),
               SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _targetDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2035),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme:  ColorScheme.dark(
                          primary: AppColors.accent,
                          onPrimary: bg,
                          surface: surface2,
                          onSurface: txtPrimary,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _targetDate = picked);
                },
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: surface3,
                    borderRadius: BorderRadius.circular(12),
                    border:  Border.fromBorderSide(
                      BorderSide(color: Color(0x12FFFFFF), width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                       Icon(Icons.calendar_month_rounded, size: 16, color: txtSecondary),
                       SizedBox(width: 8),
                      Text(
                        Formatters.dateShort(_targetDate),
                        style:  TextStyle(fontSize: 14, color: txtPrimary),
                      ),
                       Spacer(),
                      Text(
                        Formatters.daysLeft(_targetDate),
                        style:  TextStyle(fontSize: 12, color: txtSecondary),
                      ),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  child:  Text('Create Goal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
