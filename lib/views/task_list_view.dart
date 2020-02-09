import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/existing_task_view.dart';
import 'package:google_tasks_cli/views/new_task_view.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class TaskListView extends View {
  final TaskList _list;

  TaskListView(TasksApiService tasksApiService, this._list) : super(tasksApiService);

  @override
  Future<Selectable> render() async {

    var tasks = await tasksApiService.getTasks(_list.id);
    var tasksAndOptions = tasks.map((task) => task as Selectable).toList() + [ADD_NEW_TASK, END];
    var selectedTaskOrOption = prompt.choose('Select task or action', tasksAndOptions);
    if (selectedTaskOrOption == END) return selectedTaskOrOption;
    var result;
    if (selectedTaskOrOption == ADD_NEW_TASK) {
      result = await NewTaskView(tasksApiService, _list).render();
    }
    if (selectedTaskOrOption is Task) {
      result = await ExistingTaskView(tasksApiService, _list, selectedTaskOrOption).render();
    }
    if (result == REFRESH_LIST) return render();
    return DO_NOTHING;
  }
}