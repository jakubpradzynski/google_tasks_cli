import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/existing_task_view.dart';
import 'package:google_tasks_cli/views/new_task_view.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class TaskListView extends View {
  final TaskList _list;
  List<Task> tasks;
  final bool showCompleted;

  TaskListView(TasksApiService tasksApiService, this._list, {this.tasks, this.showCompleted = false})
      : super(tasksApiService);

  @override
  Future<Selectable> render() async {
    await super.render();
    tasks ??= await tasksApiService.getTasks(_list.id, showHidden: true)
      ..sort((t1, t2) => t2.status.compareTo(t1.status));
    var tasksAndOptions = tasks
            .where((task) {
              if (!showCompleted) {
                return task.status != 'completed';
              }
              return true;
            })
            .map((task) => task as Selectable)
            .toList() +
        [ADD_NEW_TASK, showCompleted ? HIDE_COMPLETED : SHOW_COMPLETED, END];
    var selectedTaskOrOption = prompt.choose('Select task or action', tasksAndOptions);
    if (selectedTaskOrOption == END) return selectedTaskOrOption;
    if (selectedTaskOrOption == SHOW_COMPLETED) {
      return TaskListView(tasksApiService, _list, tasks: tasks, showCompleted: true).render();
    }
    if (selectedTaskOrOption == HIDE_COMPLETED) {
      return TaskListView(tasksApiService, _list, tasks: tasks, showCompleted: false).render();
    }
    var result;
    if (selectedTaskOrOption == ADD_NEW_TASK) result = await NewTaskView(tasksApiService, _list).render();
    if (selectedTaskOrOption is Task) {
      result = await ExistingTaskView(tasksApiService, _list, selectedTaskOrOption).render();
    }
    if (result == REFRESH_LIST) return TaskListView(tasksApiService, _list, showCompleted: showCompleted).render();
    return DO_NOTHING;
  }
}
