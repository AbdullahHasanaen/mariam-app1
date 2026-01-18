import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/fitness_provider.dart';
import '../models/workout_routine.dart';

/// Fitness Coach screen with workout routines and reminders
class FitnessCoachScreen extends StatefulWidget {
  const FitnessCoachScreen({super.key});

  @override
  State<FitnessCoachScreen> createState() => _FitnessCoachScreenState();
}

class _FitnessCoachScreenState extends State<FitnessCoachScreen> {
  int _selectedLevel = 0; // 0: Beginner, 1: Intermediate, 2: Advanced

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FitnessProvider>().loadWorkoutRoutines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fitnessProvider = context.watch<FitnessProvider>();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Personal Fitness Coach'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Reminders section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.workoutReminders,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildReminderCard(context, l10n.runningReminder, CupertinoIcons.sportscourt, l10n),
                    const SizedBox(height: 8),
                    _buildReminderCard(context, l10n.waterReminder, CupertinoIcons.drop, l10n),
                  ],
                ),
              ),
            ),

            // Workout routines section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeWorkouts,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Level selector
                    CupertinoSlidingSegmentedControl<int>(
                      groupValue: _selectedLevel,
                      onValueChanged: (value) {
                        setState(() {
                          _selectedLevel = value ?? 0;
                        });
                      },
                      children: {
                        0: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(l10n.beginner),
                        ),
                        1: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(l10n.intermediate),
                        ),
                        2: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(l10n.advanced),
                        ),
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Workout routines list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final levelMap = {'beginner': 0, 'intermediate': 1, 'advanced': 2};
                  final levelName = ['beginner', 'intermediate', 'advanced'][_selectedLevel];
                  final routines = fitnessProvider.getRoutinesByLevel(levelName);

                  if (index >= routines.length) return null;

                  final routine = routines[index];
                  return _buildWorkoutRoutineCard(context, routine, l10n);
                },
                childCount: fitnessProvider.getRoutinesByLevel(
                  ['beginner', 'intermediate', 'advanced'][_selectedLevel],
                ).length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context, String title, IconData icon, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: CupertinoColors.activeBlue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reminder every 16 hours',
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutRoutineCard(BuildContext context, WorkoutRoutine routine, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          _showWorkoutDetails(context, routine, l10n);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      routine.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${routine.durationMinutes} min',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${routine.exercises.length} exercises',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkoutDetails(BuildContext context, WorkoutRoutine routine, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoPopupSurface(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      routine.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(CupertinoIcons.xmark_circle_fill, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Duration: ${routine.durationMinutes} minutes',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Exercises:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: routine.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = routine.exercises[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. ${exercise.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              exercise.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sets: ${exercise.sets} | Reps: ${exercise.reps} | Rest: ${exercise.restSeconds}s',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
