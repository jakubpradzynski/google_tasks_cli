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
    print('List - ${_list.title}');
    tasks ??= taskListsRepository.getTasks(_list.id)..sort((t1, t2) => t2.status.compareTo(t1.status));
    var tasksAndOptions = tasks
            .where((task) {
              if (!showCompleted) {
                return task.status != 'completed';
              }
              return true;
            })
            .map((task) => task as Selectable)
            .toList() +
        [
          ADD_NEW_TASK,
          showCompleted ? HIDE_COMPLETED : SHOW_COMPLETED,
          CLEAR_COMPLETED_TASKS,
          EDIT_LIST_NAME,
          DELETE_LIST,
          BACK
        ];
    var selectedTaskOrOption = prompt.choose('Select task or action', tasksAndOptions);
    if (selectedTaskOrOption == BACK) return BACK;
    if (selectedTaskOrOption == SHOW_COMPLETED) {
      return TaskListView(taskListsRepository, _list, tasks: tasks, showCompleted: true).render();
    }
    if (selectedTaskOrOption == HIDE_COMPLETED) {
      return TaskListView(taskListsRepository, _list, tasks: tasks, showCompleted: false).render();
    }
    if (selectedTaskOrOption == CLEAR_COMPLETED_TASKS) {
      await taskListsRepository.deleteTasks(
          _list.id, tasks.where((task) => task.status == 'completed').map((task) => task.id).toList());
      return TaskListView(taskListsRepository, _list, showCompleted: showCompleted).render();
    }
    if (selectedTaskOrOption == EDIT_LIST_NAME) {
      var newListName = prompt.get('New list name:', defaultsTo: _list.title);
      await taskListsRepository.updateTaskListTitle(_list.id, newListName);
    }
    if (selectedTaskOrOption == DELETE_LIST) {
      await taskListsRepository.deleteTaskList(_list.id);
    }
    var result;
    if (selectedTaskOrOption == ADD_NEW_TASK) result = await NewTaskView(taskListsRepository, _list).render();
    if (selectedTaskOrOption is Task) {
      result = await ExistingTaskView(taskListsRepository, _list, selectedTaskOrOption).render();
    }
    if (result == BACK) return TaskListView(taskListsRepository, _list, showCompleted: showCompleted).render();
    if (result == REFRESH) return TaskListView(taskListsRepository, _list, showCompleted: showCompleted).render();
    return DO_NOTHING;
  }
}
