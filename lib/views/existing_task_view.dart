import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/utils/date_utils.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class ExistingTaskView extends View {
  final TaskList _list;
  final Task _task;

  ExistingTaskView(TasksApiService tasksApiService, this._list, this._task) : super(tasksApiService);

  @override
  Future<Selectable> render() async {
    await super.render();
    print('Task - ${_task.title}');
    print('Notes - ${_task.notes}');
    print('Due date - ${_task.due}');
    var selectedOption = prompt.choose('What do you want to do with your task?', [EDIT, MARK_AS_COMPLETE, DELETE, END]);
    if (selectedOption == END) return END;
    if (selectedOption == EDIT) {
      var editedTitle = prompt.get('New task title:', defaultsTo: _task.title);
      var editedNotes = prompt.get('New task note:', defaultsTo: _task.notes, allowMultiline: true);
      var editedDueDate =
          prompt.get('New due date, example "2020-01-01":', defaultsTo: dateFromDateTime(_task.due)) + 'T00:00:00.0Z';
      await tasksApiService.updateTaskTitle(_list.id, _task.id,
          newTitle: editedTitle, newNotes: editedNotes, newDueDate: editedDueDate);
    }
    if (selectedOption == MARK_AS_COMPLETE) {
      await tasksApiService.markTaskAsComplete(_list.id, _task.id);
    }
    if (selectedOption == DELETE) {
      await tasksApiService.deleteTask(_list.id, _task.id);
    }
    return REFRESH_LIST;
  }
}
