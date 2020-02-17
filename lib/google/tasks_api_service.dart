import 'package:google_tasks_cli/google/models.dart' as models;
import 'package:googleapis/tasks/v1.dart';

class TasksApiService {
  TasksApi _tasksApi;

  TasksApiService(TasksApi tasksApi) {
    _tasksApi = tasksApi;
  }

  Future<List<models.TaskList>> getTaskLists() async {
    var taskLists = [];
    var result, items, nextPageToken;
    do {
      result = await _tasksApi.tasklists.list(maxResults: '100', pageToken: nextPageToken);
      items = result.items ?? [];
      taskLists.addAll(items);
      nextPageToken = result.nextPageToken;
    } while (items.length >= 100 && result.nextPageToken != null);
    return taskLists.map((item) => models.TaskList(item.id, item.title)).toList();
  }

  Future<List<models.Task>> getTasks(String listId, {bool showHidden = false}) async {
    var tasks = [];
    var result, items, nextPageToken;
    do {
      result = await _tasksApi.tasks.list(listId, showHidden: showHidden, maxResults: '100', pageToken: nextPageToken);
      items = result.items ?? [];
      tasks.addAll(items);
      nextPageToken = result.nextPageToken;
    } while (items.length >= 100 && result.nextPageToken != null);
    return tasks.map((task) => models.Task(task.id, task.title, task.status)).toList();
  }

  Future<models.Task> addTaskToList(String listId, String task) => _tasksApi.tasks
      .insert(Task()..title = task, listId)
      .then((task) => task != null ? models.Task(task.id, task.title, task.status) : null);

  Future<dynamic> deleteTask(String listId, String taskId) => _tasksApi.tasks.delete(listId, taskId);

  Future<Task> markTaskAsComplete(String listId, String taskId) => _tasksApi.tasks.update(
      Task.fromJson({'id': taskId, 'status': 'completed', 'completed': DateTime.now().toUtc().toIso8601String()}),
      listId,
      taskId);

  Future<Task> updateTaskTitle(String listId, String taskId, String title) =>
      _tasksApi.tasks.update(Task.fromJson({'id': taskId, 'title': title}), listId, taskId);
}
