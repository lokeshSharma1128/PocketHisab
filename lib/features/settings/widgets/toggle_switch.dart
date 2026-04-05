import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ToggleSwitch extends StatefulWidget {
  final bool value;
  final void Function(bool) onChanged;

  const ToggleSwitch({required this.value, required this.onChanged});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch>
    with SingleTickerProviderStateMixin {
  late bool _val;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: _val ? 1.0 : 0.0,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(ToggleSwitch old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _val = widget.value;
      _val ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _val = !_val);
    _val ? _ctrl.forward() : _ctrl.reverse();
    widget.onChanged(_val);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final t = _anim.value;
          final trackColor = Color.lerp(
            AppColors.surface3(context),
            AppColors.accent,
            t,
          )!;
          final thumbColor = Color.lerp(
            AppColors.textTertiary(context),
            AppColors.darkBg,
            t,
          )!;

          return Container(
            width: 44,
            height: 25,
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.lerp(
                  AppColors.border(context),
                  AppColors.accent,
                  t,
                )!,
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: Align(
                alignment: Alignment.lerp(
                    Alignment.centerLeft, Alignment.centerRight, t)!,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: thumbColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}