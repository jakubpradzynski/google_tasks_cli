import 'dart:async';

import 'package:google_tasks_cli/models.dart' as models;
import 'package:googleapis/tasks/v1.dart';

class TasksApiService {
  TasksApi _tasksApi;

  TasksApiService(TasksApi tasksApi) {
    _tasksApi = tasksApi;
  }

  Future<List<models.TaskList>> getTaskLists() async {
    var taskLists = <TaskList>[];
    var result, items, nextPageToken;
    do {
      result = await _tasksApi.tasklists.list(maxResults: '100', pageToken: nextPageToken);
      items = result.items ?? <TaskList>[];
      taskLists.addAll(items);
      nextPageToken = result.nextPageToken;
    } while (items.length >= 100 && result.nextPageToken != null);
    return taskLists.map(_googleTaskListToTaskList).toList();
  }

  Future<List<models.Task>> getTasks(String listId, {bool showHidden = false}) async {
    var tasks = <Task>[];
    var result, items, nextPageToken;
    do {
      result = await _tasksApi.tasks.list(listId, showHidden: showHidden, maxResults: '100', pageToken: nextPageToken);
      items = result.items ?? <Task>[];
      tasks.addAll(items);
      nextPageToken = result.nextPageToken;
    } while (items.length >= 100 && result.nextPageToken != null);
    return tasks.map(_googleTaskToTask).toList();
  }

  Future<models.Task> addTaskToList(String listId, String title, {String notes, String dueDate}) {
    var request = Task.fromJson({'title': title, 'notes': notes});
    if (dueDate != null && dueDate.isNotEmpty) {
      request.due = DateTime.parse(dueDate);
    }
    return _tasksApi.tasks.insert(request, listId).then(_googleTaskToTaskIfNotNull);
  }

  Future<dynamic> deleteTask(String listId, String taskId) => _tasksApi.tasks.delete(listId, taskId);

  Future<models.Task> markTaskAsComplete(String listId, String taskId) => _tasksApi.tasks
      .update(
          Task.fromJson({'id': taskId, 'status': 'completed', 'completed': DateTime.now().toUtc().toIso8601String()}),
          listId,
          taskId)
      .then(_googleTaskToTaskIfNotNull);

  Future<models.Task> updateTask(String listId, String taskId, {String newTitle, String newNotes, String newDueDate}) {
    var request = Task.fromJson({'id': taskId, 'title': newTitle, 'notes': newNotes});
    if (newDueDate != null && newDueDate.isNotEmpty) {
      request.due = DateTime.parse(newDueDate);
    }
    return _tasksApi.tasks.update(request, listId, taskId).then(_googleTaskToTaskIfNotNull);
  }

  Future<models.TaskList> addTaskList(String newListName) =>
      _tasksApi.tasklists.insert(TaskList.fromJson({'title': newListName})).then(_googleTaskListToTaskListIfNotNull);

  Future<dynamic> deleteTaskList(String listId) => _tasksApi.tasklists.delete(listId);

  Future<models.TaskList> updateTaskListTitle(String listId, String newListName) => _tasksApi.tasklists
      .update(TaskList.fromJson({'id': listId, 'title': newListName}), listId)
      .then(_googleTaskListToTaskListIfNotNull);

  FutureOr<models.Task> _googleTaskToTaskIfNotNull(Task task) => task != null ? _googleTaskToTask(task) : null;

  models.Task _googleTaskToTask(Task task) => models.Task(task.id, task.title, task.status, task.notes, task.due);

  FutureOr<models.TaskList> _googleTaskListToTaskListIfNotNull(TaskList taskList) =>
      taskList != null ? _googleTaskListToTaskList(taskList) : null;

  models.TaskList _googleTaskListToTaskList(TaskList taskList) => models.TaskList(taskList.id, taskList.title);
}
