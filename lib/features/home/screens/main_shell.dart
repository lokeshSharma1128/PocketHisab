import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/auth_service.dart';
import '../../goals/screens/goals_screen.dart';
import '../../insights/screens/insights_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../provider/app_provider.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    TransactionsScreen(),
    GoalsScreen(),
    InsightsScreen(),
    SettingsScreen(),
  ];

  static const _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Transactions'),
    _NavItem(icon: Icons.flag_rounded, label: 'Goals'),
    _NavItem(icon: Icons.insights_rounded, label: 'Insights'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _checkBiometric();
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    // Adaptive surface colors from theme
    final bg = AppColors.bg(context);
    final surface = AppColors.surface(context);

    final txtTertiary = AppColors.textTertiary(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: surface,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bg,
        body: IndexedStack(
          index: app.currentIndex,
          children: MainShell._screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: surface,
            border: Border(
              top: BorderSide(color: Color(0x0DFFFFFF), width: 0.5),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(MainShell._navItems.length, (i) {
                  final item = MainShell._navItems[i];
                  final isActive = app.currentIndex == i;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      app.setIndex(i);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.accent.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 22,
                            color: isActive ? AppColors.accent : txtTertiary,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isActive
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: isActive ? AppColors.accent : txtTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
