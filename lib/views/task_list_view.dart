import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';
import 'package:google_tasks_cli/views/existing_task_view.dart';
import 'package:google_tasks_cli/views/new_task_view.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class TaskListView extends View {
  final TaskList _list;
  List<Task> tasks;
  final bool showCompleted;

  TaskListView(TaskListsRepository taskListsRepository, this._list, {this.tasks, this.showCompleted = false})
      : super(taskListsRepository);

  @override
  Future<Selectable> render() async {
    await super.render();
    _printTaskList();
    tasks ??= _getSortedTasks();
    var tasksAndOptions = _filterTasksToShow() + _getAllowedOptions();
    var selectedTaskOrOption = prompt.choose('Select task or action', tasksAndOptions);
    if (selectedTaskOrOption == BACK) return BACK;
    if ([SHOW_COMPLETED, HIDE_COMPLETED].contains(selectedTaskOrOption)) {
      return TaskListView(taskListsRepository, _list, tasks: tasks, showCompleted: !showCompleted).render();
    }
    if (selectedTaskOrOption == CLEAR_COMPLETED_TASKS) {
      await taskListsRepository.deleteTasks(
          _list.id, tasks.where((task) => task.status == 'completed').map((task) => task.id).toList());
    }
    if (selectedTaskOrOption == EDIT_LIST_NAME) await _editListName();
    if (selectedTaskOrOption == DELETE_LIST) return await _deleteTaskList();
    if (selectedTaskOrOption == ADD_NEW_TASK) await NewTaskView(taskListsRepository, _list).render();
    if (selectedTaskOrOption is Task) {
      await ExistingTaskView(taskListsRepository, _list, selectedTaskOrOption).render();
    }
    return TaskListView(taskListsRepository, taskListsRepository.getTaskListById(_list.id), showCompleted: showCompleted).render();
  }

  Future<Selectable> _deleteTaskList() async {
    await taskListsRepository.deleteTaskList(_list.id);
    return REFRESH;
  }

  void _printTaskList() {
    print('List - ${_list.title}');
  }

  List<Task> _getSortedTasks() => taskListsRepository.getTasks(_list.id)..sort((t1, t2) => t2.status.compareTo(t1.status));

  List<Selectable> _filterTasksToShow() =>
      tasks.where((task) => showCompleted || (task.status != 'completed')).map((task) => task as Selectable).toList();

  List<Selectable> _getAllowedOptions() => [
        ADD_NEW_TASK,
        showCompleted ? HIDE_COMPLETED : SHOW_COMPLETED,
        CLEAR_COMPLETED_TASKS,
        EDIT_LIST_NAME,
        DELETE_LIST,
        BACK
      ];

  Future _editListName() async {
    var newListName = prompt.get('New list name:', defaultsTo: _list.title);
    await taskListsRepository.updateTaskListTitle(_list.id, newListName);
  }
}
