import 'dart:io';

import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';

class TasksForTodayNotifier {
  final TaskListsRepository _taskListsRepository;

  TasksForTodayNotifier(this._taskListsRepository);

  Future<void> notify() async {
    var tasksToNotify = _taskListsRepository.getTasksForToday();
    if (Platform.isMacOS) {
      await _notifyOnMacOS(tasksToNotify);
    }
  }

  Future<void> _notifyOnMacOS(Map<TaskList, List<Task>> tasksToNotify) async {
    print(tasksToNotify);
    for (var entry in tasksToNotify.entries) {
      for (var task in entry.value) {
        await Process.run('osascript',
            ['-e', 'display notification "Task: ${task.title}" with title "Google Tasks CLI" subtitle "List: ${entry.key.title}"']);
      }
    }
  }
}
