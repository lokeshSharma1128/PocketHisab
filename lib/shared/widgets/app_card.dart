import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius = 18,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptive surface colors from theme
    final surface = AppColors.surface(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color ?? surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border:
          border ?? Border.all(color: const Color(0x12FFFFFF), width: 0.5),
        ),
        child: child,
      ),
    );
  }
}