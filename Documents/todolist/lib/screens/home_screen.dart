import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/settings_provider.dart';
import '../providers/fitness_provider.dart';
import 'task_list_screen.dart';
import 'fitness_coach_screen.dart';
import 'settings_screen.dart';

/// Home screen with navigation to Task Reminder and Fitness Coach
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize fitness reminders when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FitnessProvider>().scheduleFitnessReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();
    final userName = settingsProvider.userName.isEmpty
        ? l10n.welcome
        : l10n.welcomeUser(settingsProvider.userName);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeContent(context, userName, l10n),
            const TaskListScreen(),
            const FitnessCoachScreen(),
            const SettingsScreen(),
          ],
        ),
      ),
      navigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            label: l10n.welcome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.check_mark_circled),
            label: l10n.taskReminder,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.sportscourt),
            label: l10n.fitnessCoach,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, String welcomeText, AppLocalizations l10n) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text(l10n.appTitle),
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  welcomeText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildModuleCard(
                  context,
                  icon: CupertinoIcons.check_mark_circled,
                  title: l10n.taskReminder,
                  description: 'Manage your tasks and reminders',
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildModuleCard(
                  context,
                  icon: CupertinoIcons.sportscourt,
                  title: l10n.fitnessCoach,
                  description: 'Home workouts and fitness reminders',
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: CupertinoColors.activeBlue),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right),
          ],
        ),
      ),
    );
  }
}
