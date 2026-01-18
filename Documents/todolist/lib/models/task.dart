/// Task model for Task Reminder module
class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime time;
  final String priority; // 'low', 'medium', 'high'
  final String status; // 'pending', 'completed'

  Task({
    this.id,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    required this.priority,
    required this.status,
  });

  /// Convert Task to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description ?? '',
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'priority': priority,
      'status': status,
    };
  }

  /// Create Task from Map retrieved from database
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      priority: map['priority'] as String,
      status: map['status'] as String,
    );
  }

  /// Create a copy of Task with updated fields
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? time,
    String? priority,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  /// Get the combined date and time for notification scheduling
  DateTime get notificationDateTime {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}
