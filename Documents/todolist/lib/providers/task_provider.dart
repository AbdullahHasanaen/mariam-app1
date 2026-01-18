import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';

/// Provider for managing tasks state
class TaskProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final NotificationService _notifications = NotificationService.instance;

  List<Task> _pendingTasks = [];
  List<Task> _completedTasks = [];

  List<Task> get pendingTasks => _pendingTasks;
  List<Task> get completedTasks => _completedTasks;

  /// Load all tasks from database
  Future<void> loadTasks() async {
    _pendingTasks = await _db.getPendingTasks();
    _completedTasks = await _db.getCompletedTasks();
    notifyListeners();
  }

  /// Create a new task
  Future<void> createTask(Task task) async {
    final id = await _db.insertTask(task);
    final newTask = task.copyWith(id: id);
    
    // Schedule notification if date/time is in the future
    final notificationDateTime = newTask.notificationDateTime;
    if (notificationDateTime.isAfter(DateTime.now())) {
      await _notifications.scheduleTaskNotification(
        id: newTask.id!,
        title: 'Task Reminder',
        body: newTask.title,
        scheduledDate: notificationDateTime,
        payload: newTask.id.toString(),
      );
    }

    await loadTasks();
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    // Cancel old notification
    if (task.id != null) {
      await _notifications.cancelNotification(task.id!);
    }

    await _db.updateTask(task);

    // Schedule new notification if date/time is in the future
    final notificationDateTime = task.notificationDateTime;
    if (notificationDateTime.isAfter(DateTime.now())) {
      await _notifications.scheduleTaskNotification(
        id: task.id!,
        title: 'Task Reminder',
        body: task.title,
        scheduledDate: notificationDateTime,
        payload: task.id.toString(),
      );
    }

    await loadTasks();
  }

  /// Delete a task
  Future<void> deleteTask(int id) async {
    // Cancel notification
    await _notifications.cancelNotification(id);
    
    await _db.deleteTask(id);
    await loadTasks();
  }

  /// Mark task as completed
  Future<void> completeTask(Task task) async {
    // Cancel notification
    if (task.id != null) {
      await _notifications.cancelNotification(task.id!);
    }

    await _db.completeTask(task);
    await loadTasks();
  }
}
