import 'package:flutter/foundation.dart';
import '../models/workout_routine.dart';
import '../services/notification_service.dart';
import '../services/database_helper.dart';
import '../services/settings_service.dart';

/// Provider for managing fitness coach state
class FitnessProvider with ChangeNotifier {
  final NotificationService _notifications = NotificationService.instance;
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SettingsService _settings = SettingsService.instance;

  List<WorkoutRoutine> _workoutRoutines = [];

  List<WorkoutRoutine> get workoutRoutines => _workoutRoutines;

  /// Load workout routines
  Future<void> loadWorkoutRoutines() async {
    _workoutRoutines = WorkoutRoutines.getAllRoutines();
    notifyListeners();
  }

  /// Get workout routines by level
  List<WorkoutRoutine> getRoutinesByLevel(String level) {
    return WorkoutRoutines.getRoutinesByLevel(level);
  }

  /// Schedule fitness reminders (every 16 hours)
  Future<void> scheduleFitnessReminders() async {
    // Check if notifications are enabled
    if (!_settings.getNotificationsEnabled()) {
      return;
    }

    // Schedule running reminder (ID: 1000)
    await _notifications.scheduleFitnessReminder(
      id: 1000,
      title: 'Running Reminder',
      body: 'Time for your running session!',
      intervalHours: 16,
      payload: 'running',
    );

    // Schedule water reminder (ID: 1001)
    await _notifications.scheduleFitnessReminder(
      id: 1001,
      title: 'Water Drinking Reminder',
      body: 'Don\'t forget to drink water!',
      intervalHours: 16,
      payload: 'water',
    );
  }

  /// Cancel fitness reminders
  Future<void> cancelFitnessReminders() async {
    await _notifications.cancelNotification(1000);
    await _notifications.cancelNotification(1001);
  }
}
