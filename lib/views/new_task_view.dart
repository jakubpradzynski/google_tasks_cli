import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class NewTaskView extends View {
  final TaskList _list;

  NewTaskView(TasksApiService tasksApiService, this._list) : super(tasksApiService);

  @override
  Future<Selectable> render() async {
    await super.render();
    var newTask = prompt.get('Your new task');
    await tasksApiService.addTaskToList(_list.id, newTask);
    return REFRESH_LIST;
  }
}
