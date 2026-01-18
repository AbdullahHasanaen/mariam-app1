import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

/// Database helper for SQLite operations
/// Handles all local database interactions
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wellness_app.db');
    return _database!;
  }

  /// Initialize database and create tables
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create all database tables
  Future<void> _createDB(Database db, int version) async {
    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    // Completed tasks table
    await db.execute('''
      CREATE TABLE completed_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        priority TEXT NOT NULL,
        completed_at TEXT NOT NULL
      )
    ''');

    // Fitness reminders table (for tracking reminder state)
    await db.execute('''
      CREATE TABLE fitness_reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reminder_type TEXT NOT NULL UNIQUE,
        last_reminder_time TEXT,
        enabled INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Initialize fitness reminders
    await db.insert('fitness_reminders', {
      'reminder_type': 'running',
      'enabled': 1,
    });
    await db.insert('fitness_reminders', {
      'reminder_type': 'water',
      'enabled': 1,
    });
  }

  // ==================== TASK OPERATIONS ====================

  /// Create a new task
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  /// Get all pending tasks
  Future<List<Task>> getPendingTasks() async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'date ASC, time ASC',
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  /// Get all completed tasks
  Future<List<Task>> getCompletedTasks() async {
    final db = await database;
    final maps = await db.query(
      'completed_tasks',
      orderBy: 'completed_at DESC',
    );
    return maps.map((map) {
      // Convert completed_tasks map to Task format
      return Task(
        id: map['id'],
        title: map['title'] as String,
        description: map['description'] as String?,
        date: DateTime.parse(map['date'] as String),
        time: DateTime.parse(map['time'] as String),
        priority: map['priority'] as String,
        status: 'completed',
      );
    }).toList();
  }

  /// Get a single task by ID
  Future<Task?> getTask(int id) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  /// Update a task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Delete a task
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Mark task as completed and move to completed_tasks
  Future<void> completeTask(Task task) async {
    final db = await database;
    await db.transaction((txn) async {
      // Insert into completed_tasks
      await txn.insert('completed_tasks', {
        'title': task.title,
        'description': task.description ?? '',
        'date': task.date.toIso8601String(),
        'time': task.time.toIso8601String(),
        'priority': task.priority,
        'completed_at': DateTime.now().toIso8601String(),
      });
      // Delete from tasks
      await txn.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [task.id],
      );
    });
  }

  // ==================== FITNESS REMINDER OPERATIONS ====================

  /// Get fitness reminder state
  Future<Map<String, dynamic>?> getFitnessReminder(String reminderType) async {
    final db = await database;
    final maps = await db.query(
      'fitness_reminders',
      where: 'reminder_type = ?',
      whereArgs: [reminderType],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  /// Update fitness reminder last time
  Future<int> updateFitnessReminderTime(String reminderType) async {
    final db = await database;
    return await db.update(
      'fitness_reminders',
      {
        'last_reminder_time': DateTime.now().toIso8601String(),
      },
      where: 'reminder_type = ?',
      whereArgs: [reminderType],
    );
  }

  /// Enable or disable fitness reminder
  Future<int> setFitnessReminderEnabled(String reminderType, bool enabled) async {
    final db = await database;
    return await db.update(
      'fitness_reminders',
      {
        'enabled': enabled ? 1 : 0,
      },
      where: 'reminder_type = ?',
      whereArgs: [reminderType],
    );
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
