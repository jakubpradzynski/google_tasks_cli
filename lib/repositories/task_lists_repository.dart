import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/utils/date_utils.dart';

class TaskListsRepository {
  final TasksApiService _tasksApiService;

  TaskListsRepository(this._tasksApiService);

  final List<TaskList> _taskLists = [];
  final Map<String, List<Task>> _tasksPerList = {};

  Future<void> synchronizeData() async {
    _taskLists.clear();
    _tasksPerList.clear();
    _taskLists.addAll(await _tasksApiService.getTaskLists());
    for (var taskList in _taskLists) {
      var tasks = await _tasksApiService.getTasks(taskList.id, showHidden: true);
      _tasksPerList[taskList.id] = tasks;
    }
  }

  List<TaskList> get taskLists => _taskLists;

  TaskList getTaskListById(String listId) => _taskLists.where((taskList) => taskList.id == listId).first;

  List<Task> getTasks(String listId) => _tasksPerList[listId] ?? [];

  Map<TaskList, List<Task>> getTasksForToday() {
    Map<TaskList, List<Task>> result = {};
    _tasksPerList.forEach((listId, tasks) {
      var tasksForToday = tasks.where((task) => isSameDay(task.due, DateTime.now())).toList();
      if (tasksForToday.isNotEmpty) {
        result.putIfAbsent(getTaskListById(listId), () => tasksForToday);
      }
    });
    return result;
  }

  Future<void> addTaskList(String newListName) async {
    var newTaskList = await _tasksApiService.addTaskList(newListName);
    _taskLists.add(newTaskList);
    _tasksPerList[newTaskList.id] == [];
  }

  Future<void> addTaskToList(String listId, String newTaskTitle, {String notes, String dueDate}) async {
    var newTask = await _tasksApiService.addTaskToList(listId, newTaskTitle, notes: notes, dueDate: dueDate);
    if (newTask != null) {
      _tasksPerList.update(listId, (tasks) => tasks..add(newTask), ifAbsent: () => [newTask]);
    }
  }

  Future<void> updateTask(String listId, String taskId, {String newTitle, String newNotes, String newDueDate}) async {
    var updatedTask = await _tasksApiService.updateTask(listId, taskId,
        newTitle: newTitle, newNotes: newNotes, newDueDate: newDueDate);
    if (updatedTask != null) {
      _tasksPerList.update(listId, (tasks) {
        tasks.removeWhere((task) => task.id == updatedTask.id);
        return tasks..add(updatedTask);
      }, ifAbsent: () => [updatedTask]);
    }
  }

  Future<void> markTaskAsComplete(String listId, String taskId) async {
    var completedTask = await _tasksApiService.markTaskAsComplete(listId, taskId);
    if (completedTask != null) {
      _tasksPerList.update(listId, (tasks) {
        tasks.removeWhere((task) => task.id == completedTask.id);
        return tasks..add(completedTask);
      }, ifAbsent: () => [completedTask]);
    }
  }

  Future<void> deleteTask(String listId, String taskId) async {
    try {
      await _tasksApiService.deleteTask(listId, taskId);
      _tasksPerList[listId] = _tasksPerList[listId]..removeWhere((task) => task.id == taskId);
    } catch (err) {
      print('Could not delete task $taskId - $err');
    }
  }

  Future<void> deleteTasks(String listId, List<String> taskIds) async {
    var removedTasks = <String>[];
    for (var taskId in taskIds) {
      try {
        await _tasksApiService.deleteTask(listId, taskId);
        removedTasks.add(taskId);
      } catch (err) {
        print('Could not delete task $taskId - $err');
      }
    }
    _tasksPerList[listId] = _tasksPerList[listId]..removeWhere((task) => removedTasks.contains(task.id));
  }

  Future<void> updateTaskListTitle(String listId, String newListName) async {
    var updatedTaskList = await _tasksApiService.updateTaskListTitle(listId, newListName);
    if (updatedTaskList != null) {
      _taskLists.removeWhere((taskList) => taskList.id == listId);
      _taskLists.add(updatedTaskList);
    }
  }

  Future<void> deleteTaskList(String listId) async {
    try {
      await _tasksApiService.deleteTaskList(listId);
      _taskLists.removeWhere((taskList) => taskList.id == listId);
    } catch (err) {
      print('Could not delete task list $listId - $err');
    }
  }
}
