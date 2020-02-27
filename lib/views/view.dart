import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';

abstract class View {
  final TaskListsRepository _taskListsRepository;

  View(this._taskListsRepository);

  Future<Selectable> render() {
    _clearConsole();
  }

  TaskListsRepository get taskListsRepository => _taskListsRepository;
}

void _clearConsole() {
  print('\x1B[2J\x1B[0;0H');
  print('\nGoogle Tasks CLI\n');
}
