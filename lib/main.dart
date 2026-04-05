import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/local/hive_service.dart';
import 'data/local/seed_data.dart';
import 'data/repositories/transaction_repository.dart';
import 'data/repositories/goal_repository.dart';
import 'features/goals/provider/goal_provider.dart';
import 'features/home/provider/app_provider.dart';
import 'features/transactions/provider/transaction_provider.dart';
import 'features/home/screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar is transparent; icon brightness is controlled per-theme
  // via AppBarTheme.systemOverlayStyle in app_theme.dart.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await HiveService.init();
  // await HiveService.settingsBox.delete(AppConstants.themeModeKey);
  await SeedDataService.seedIfEmpty();

  runApp(const PennyApp());
}

class PennyApp extends StatelessWidget {
  const PennyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        Provider<TransactionRepository>(create: (_) => TransactionRepository()),
        Provider<GoalRepository>(create: (_) => GoalRepository()),
        Provider<BudgetRepository>(create: (_) => BudgetRepository()),
        ChangeNotifierProxyProvider<TransactionRepository, TransactionProvider>(
          create: (ctx) => TransactionProvider(ctx.read<TransactionRepository>()),
          update: (ctx, repo, prev) => prev ?? TransactionProvider(repo),
        ),
        ChangeNotifierProxyProvider2<GoalRepository, BudgetRepository, GoalProvider>(
          create: (ctx) => GoalProvider(ctx.read<GoalRepository>(), ctx.read<BudgetRepository>()),
          update: (ctx, goalRepo, budgetRepo, prev) =>
          prev ?? GoalProvider(goalRepo, budgetRepo),
        ),
      ],
      // ── Consumer sits here so MaterialApp rebuilds on theme changes ────────
      child: Consumer<AppProvider>(
        builder: (context, app, _) {
          return MaterialApp(
            title: 'Pocket Hisab',
            debugShowCheckedModeBanner: false,
            // ThemeMode.system → OS decides; .light / .dark → explicit override
            themeMode: app.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const MainShell(),
          );
        },
      ),
    );
  }
}
