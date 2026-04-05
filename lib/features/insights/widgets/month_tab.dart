import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class MonthTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const MonthTab(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {


    // Adaptive surface colors from theme

    final surface3  = AppColors.surface3(context);

    final txtSecondary  = AppColors.textSecondary(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent.withOpacity(0.15) : surface3,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.accent : const Color(0x12FFFFFF),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.accent : txtSecondary),
        ),
      ),
    );
  }
}
