import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';

abstract class View {
  final TasksApiService _tasksApiService;
  View(this._tasksApiService);
  Future<Selectable> render() {}

  TasksApiService get tasksApiService => _tasksApiService;
}