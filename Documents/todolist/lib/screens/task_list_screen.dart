import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/task_provider.dart';
import '../models/task.dart';
import 'task_edit_screen.dart';

/// Task list screen showing pending and completed tasks
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _selectedSegment = 0; // 0: Pending, 1: Completed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final taskProvider = context.watch<TaskProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.taskReminder),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => TaskEditScreen(),
              ),
            ).then((_) {
              context.read<TaskProvider>().loadTasks();
            });
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedSegment,
                onValueChanged: (value) {
                  setState(() {
                    _selectedSegment = value ?? 0;
                  });
                },
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(l10n.tasks),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(l10n.completedTasks),
                  ),
                },
              ),
            ),
            Expanded(
              child: _selectedSegment == 0
                  ? _buildPendingTasksList(context, taskProvider.pendingTasks, l10n)
                  : _buildCompletedTasksList(context, taskProvider.completedTasks, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTasksList(BuildContext context, List<Task> tasks, AppLocalizations l10n) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.check_mark_circled_solid, size: 60, color: CupertinoColors.systemGrey),
            const SizedBox(height: 16),
            Text(
              l10n.noTasks,
              style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskTile(context, task, l10n, isPending: true);
      },
    );
  }

  Widget _buildCompletedTasksList(BuildContext context, List<Task> tasks, AppLocalizations l10n) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.check_mark_circled, size: 60, color: CupertinoColors.systemGrey),
            const SizedBox(height: 16),
            Text(
              l10n.noCompletedTasks,
              style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskTile(context, task, l10n, isPending: false);
      },
    );
  }

  Widget _buildTaskTile(BuildContext context, Task task, AppLocalizations l10n, {required bool isPending}) {
    Color priorityColor;
    switch (task.priority) {
      case 'high':
        priorityColor = CupertinoColors.systemRed;
        break;
      case 'medium':
        priorityColor = CupertinoColors.systemOrange;
        break;
      default:
        priorityColor = CupertinoColors.systemBlue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: CupertinoListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: isPending ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: CupertinoColors.secondaryLabel),
              ),
            const SizedBox(height: 4),
            Text(
              '${_formatDate(task.date)} at ${_formatTime(task.time)}',
              style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 12),
            ),
          ],
        ),
        leading: Container(
          width: 4,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        trailing: isPending
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      context.read<TaskProvider>().completeTask(task);
                    },
                    child: const Icon(CupertinoIcons.check_mark, size: 20),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => TaskEditScreen(task: task),
                        ),
                      ).then((_) {
                        context.read<TaskProvider>().loadTasks();
                      });
                    },
                    child: const Icon(CupertinoIcons.pencil, size: 20),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      _showDeleteDialog(context, task, l10n);
                    },
                    child: const Icon(CupertinoIcons.delete, size: 20, color: CupertinoColors.destructiveRed),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Task task, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.deleteTask),
        content: Text('${l10n.deleteTask} "${task.title}"?'),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(l10n.deleteTask),
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
