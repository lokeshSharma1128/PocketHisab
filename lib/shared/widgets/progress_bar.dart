import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class PennyProgressBar extends StatelessWidget {
  final double progress;
  final Color? color;
  final double height;

  const PennyProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme

    final surface3 = AppColors.surface3(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: surface3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppColors.accent,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}