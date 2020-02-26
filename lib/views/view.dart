import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';

abstract class View {
  final TasksApiService _tasksApiService;

  View(this._tasksApiService);

  Future<Selectable> render() {
    _clearConsole();
  }

  TasksApiService get tasksApiService => _tasksApiService;
}

void _clearConsole() {
  print('\x1B[2J\x1B[0;0H');
  print('\nGoogle Tasks CLI\n');
}
