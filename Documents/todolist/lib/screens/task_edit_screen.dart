import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

/// Screen for creating or editing tasks
class TaskEditScreen extends StatefulWidget {
  final Task? task;

  const TaskEditScreen({super.key, this.task});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late DateTime _selectedTime;
  late String _priority;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _selectedDate = task?.date ?? DateTime.now();
    _selectedTime = task?.time ?? DateTime.now();
    _priority = task?.priority ?? 'medium';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.task == null ? l10n.createTask : l10n.editTask),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saveTask,
          child: Text(l10n.save),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.taskTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CupertinoTextField(
              controller: _titleController,
              placeholder: l10n.taskTitle,
              padding: const EdgeInsets.all(12),
            ),
            const SizedBox(height: 24),

            // Description field
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.taskDescription,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CupertinoTextField(
              controller: _descriptionController,
              placeholder: l10n.taskDescription,
              padding: const EdgeInsets.all(12),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Date picker
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.taskDate,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _selectDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(_selectedDate)),
                    const Icon(CupertinoIcons.calendar),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Time picker
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.taskTime,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _selectTime,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatTime(_selectedTime)),
                    const Icon(CupertinoIcons.clock),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Priority selector
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.taskPriority,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CupertinoSlidingSegmentedControl<String>(
              groupValue: _priority,
              onValueChanged: (value) {
                setState(() {
                  _priority = value ?? 'medium';
                });
              },
              children: {
                'low': Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.priorityLow),
                ),
                'medium': Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.priorityMedium),
                ),
                'high': Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(l10n.priorityHigh),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedDate,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            minimumDate: DateTime.now(),
            onDateTimeChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),
      ),
    );
  }

  void _selectTime() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedTime,
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            onDateTimeChanged: (time) {
              setState(() {
                _selectedTime = time;
              });
            },
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a task title'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    final taskProvider = context.read<TaskProvider>();
    final task = Task(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      date: _selectedDate,
      time: _selectedTime,
      priority: _priority,
      status: widget.task?.status ?? 'pending',
    );

    if (widget.task == null) {
      taskProvider.createTask(task);
    } else {
      taskProvider.updateTask(task);
    }

    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
