import 'package:google_tasks_cli/google/models.dart' as models;
import 'package:googleapis/tasks/v1.dart';

class TasksApiService {
  TasksApi _tasksApi;

  TasksApiService(TasksApi tasksApi) {
    _tasksApi = tasksApi;
  }

  Future<List<models.TaskList>> getTaskLists() => _tasksApi.tasklists
      .list()
      .then((list) => list.items != null ? list.items.map((item) => models.TaskList(item.id, item.title)).toList() : []);

  Future<List<models.Task>> getTasks(String listId) => _tasksApi.tasks
      .list(listId)
      .then((tasks) => tasks.items != null ? tasks.items.map((task) => models.Task(task.id, task.title)).toList() : []);

  Future<models.Task> addTaskToList(String listId, String task) => _tasksApi.tasks.insert(Task()..title = task, listId)
    .then((task) => task != null ? models.Task(task.id, task.title) : null);

  Future<dynamic> deleteTask(String listId, String taskId) => _tasksApi.tasks.delete(listId, taskId);

}
