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

  TaskList getTaskListById(String listId) => _taskLists.where((taskList) => taskList.id == listId).first;

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
}
