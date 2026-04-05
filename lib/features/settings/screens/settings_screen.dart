import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../core/constants/app_constants.dart';
import '../../home/provider/app_provider.dart';
import '../widgets/toggle_switch.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adaptive surface colors from theme
    final bg        = AppColors.bg(context);
    final surface   = AppColors.surface(context);
    final surface2  = AppColors.surface2(context);
    final txtPrimary    = AppColors.textPrimary(context);
    final txtSecondary  = AppColors.textSecondary(context);
    final txtTertiary   = AppColors.textTertiary(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile & Settings',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: txtPrimary)),
                    const SizedBox(height: 20),

                    // ── Profile card ─────────────────────────────────────────
                    AppCard(
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.accent, AppColors.info],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                app.userName.isNotEmpty
                                    ? app.userName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkBg),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app.userName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: txtPrimary)),
                                Text('Pocket Hisab User',
                                    style: TextStyle(
                                        fontSize: 12, color: txtSecondary)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _editName(context, app),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.surface3(context),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.edit_rounded,
                                  size: 16, color: txtSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Appearance ───────────────────────────────────────────
                    _SectionLabel('Appearance'),
                    AppCard(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      child: Column(
                        children: [
                          // Use device theme toggle
                          // _SettingRow(
                          //   icon: '📱',
                          //   label: 'Use device theme',
                          //   subtitle: 'Adapts automatically to your OS setting',
                          //   trailing: _ToggleSwitch(
                          //     value: app.followsSystem,
                          //     onChanged: (val) => app.setFollowSystem(val),
                          //   ),
                          // ),

                          // Dark mode toggle (disabled when following system)
                          AnimatedOpacity(
                            opacity:  1.0,
                            duration: const Duration(milliseconds: 200),
                            child: _SettingRow(
                              icon: isDark ? '🌙' : '☀️',
                              label: 'Dark mode',
                              // subtitle: app.isDarkModeOn == null
                              //     ? 'Using device theme'
                              //     : app.isDarkModeOn!
                              //     ? 'Dark mode enabled'
                              //     : 'Light mode enabled',
                              trailing: ToggleSwitch(
                                value: app.isDarkModeOn ?? isDark,
                                onChanged: (val) => app.setDarkMode(val),
                              ),
                              showDivider: false,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Current theme pill (informational)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 13, color: txtTertiary),
                          const SizedBox(width: 5),
                          Text(
                            _themeModeLabel(app.themeMode, isDark),
                            style: TextStyle(
                                fontSize: 11, color: txtTertiary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Preferences ──────────────────────────────────────────
                    _SectionLabel('Preferences'),
                    AppCard(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      child: Column(
                        children: [
                          // _SettingRow(
                          //   icon: '🔔',
                          //   label: 'Daily Reminders',
                          //   trailing: ToggleSwitch(value: true, onChanged: (_) {}),
                          // ),
                          // _SettingRow(
                          //   icon: '🔐',
                          //   label: 'Biometric Lock',
                          //   trailing:
                          //   ToggleSwitch(value: false, onChanged: (_) {}),
                          // ),
                          _SettingRow(
                            icon: '💱',
                            label: 'Currency',
                            trailing: Text('₹ INR',
                                style: TextStyle(
                                    fontSize: 13, color: txtSecondary)),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Data ─────────────────────────────────────────────────
                    _SectionLabel('Data'),
                    AppCard(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      child: Column(
                        children: [
                          _SettingRow(
                            icon: '📤',
                            label: 'Export Data (CSV)',
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: txtTertiary),
                            onTap: () => _showExportDialog(context),
                          ),
                          _SettingRow(
                            icon: '🔄',
                            label: 'Backup to Cloud',
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: txtTertiary),
                            onTap: () => _showBackupDialog(context),
                          ),
                          _SettingRow(
                            icon: '🗑️',
                            label: 'Clear All Data',
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: txtTertiary),
                            onTap: () => _showClearDialog(context),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── About ────────────────────────────────────────────────
                    _SectionLabel('About'),
                    AppCard(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      child: Column(
                        children: [
                          _SettingRow(
                            icon: '📱',
                            label: 'App Version',
                            trailing: Text('1.0.0',
                                style: TextStyle(
                                    fontSize: 13, color: txtSecondary)),
                          ),
                          // _SettingRow(
                          //   icon: '🔒',
                          //   label: 'Privacy Policy',
                          //   trailing: Icon(Icons.arrow_forward_ios_rounded,
                          //       size: 14, color: txtTertiary),
                          // ),
                          // _SettingRow(
                          //   icon: '📜',
                          //   label: 'Terms of Service',
                          //   trailing: Icon(Icons.arrow_forward_ios_rounded,
                          //       size: 14, color: txtTertiary),
                          //   showDivider: false,
                          // ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    Center(
                      child: Text('Made with 💚 by Pocket Hisab',
                          style:
                          TextStyle(fontSize: 12, color: txtTertiary)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode, bool isDark) {
    switch (mode) {
      case ThemeMode.system:
        return 'Currently using device theme (${isDark ? 'dark' : 'light'})';
      case ThemeMode.dark:
        return 'Dark theme set manually';
      case ThemeMode.light:
        return 'Light theme set manually';
    }
  }

  void _editName(BuildContext context, AppProvider app) {
    final ctrl = TextEditingController(text: app.userName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Name',
            style: TextStyle(
                color: AppColors.textPrimary(context), fontSize: 16)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: TextStyle(color: AppColors.textPrimary(context)),
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style:
                TextStyle(color: AppColors.textSecondary(context))),
          ),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                app.setUserName(ctrl.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV export coming soon!')),
    );
  }

  void _showBackupDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup to Cloud coming soon!')),
    );
  }

  void _showClearDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clear all data coming soon!')),
    );
  }


  // void _showClearDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('Clear All Data',
  //           style: TextStyle(
  //               color: AppColors.textPrimary(context), fontSize: 16)),
  //       content: Text(
  //           'This will permanently delete all transactions, goals and budgets.',
  //           style: TextStyle(
  //               color: AppColors.textSecondary(context), fontSize: 13)),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: Text('Cancel',
  //               style:
  //               TextStyle(color: AppColors.textSecondary(context))),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text('Delete All',
  //               style: TextStyle(
  //                   color: AppColors.expense,
  //                   fontWeight: FontWeight.w600)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary(context),
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

// ─── Setting row ──────────────────────────────────────────────────────────────
class _SettingRow extends StatelessWidget {
  final String icon;
  final String label;
  final String? subtitle;
  final Widget trailing;
  final bool showDivider;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.subtitle,
    this.showDivider = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 19)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary(context))),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(subtitle!,
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary(context))),
                      ],
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
          if (showDivider)
            Divider(
                height: 0,
                color: AppColors.border(context),
                thickness: 0.5),
        ],
      ),
    );
  }
}

