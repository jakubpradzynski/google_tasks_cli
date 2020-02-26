import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class NewTaskView extends View {
  final TaskList _list;

  NewTaskView(TasksApiService tasksApiService, this._list) : super(tasksApiService);

  @override
  Future<Selectable> render() async {
    await super.render();
    var newTaskTitle = prompt.get('Your new task:', defaultsTo: '');
    var newTaskNotes = prompt.get('Task notes:', defaultsTo: '');
    var newTaskDueDate = prompt.get('Task due date, example "2020-01-01":', defaultsTo: '');
    if (newTaskTitle != null && newTaskTitle.isNotEmpty) {
      if (newTaskDueDate != null && newTaskDueDate.isNotEmpty) newTaskDueDate += 'T00:00:00.0Z';
      await tasksApiService.addTaskToList(_list.id, newTaskTitle, notes: newTaskNotes, dueDate: newTaskDueDate);
    }
    return REFRESH_LIST;
  }
}
