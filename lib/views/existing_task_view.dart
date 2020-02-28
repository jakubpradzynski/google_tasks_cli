import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';
import 'package:google_tasks_cli/utils/date_utils.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class ExistingTaskView extends View {
  final TaskList _list;
  final Task _task;

  ExistingTaskView(TaskListsRepository taskListsRepository, this._list, this._task) : super(taskListsRepository);

  @override
  Future<Selectable> render() async {
    await super.render();
    _printTask();
    var selectedOption = prompt.choose('What do you want to do with your task?', _getAllowedOptions());
    if (selectedOption == EDIT_TASK) await _editTask();
    if (selectedOption == MARK_AS_COMPLETE) await taskListsRepository.markTaskAsComplete(_list.id, _task.id);
    if (selectedOption == DELETE_TASK) await taskListsRepository.deleteTask(_list.id, _task.id);
    if (selectedOption == BACK) return BACK;
    return REFRESH;
  }

  void _printTask() {
    print('Task - ${_task.title}');
    print('Notes - ${_task.notes}');
    print('Due date - ${_task.due}');
  }

  List<PredefinedOption> _getAllowedOptions() => [EDIT_TASK, MARK_AS_COMPLETE, DELETE_TASK, BACK];

  Future _editTask() async {
    var editedTitle = prompt.get('New task title:', defaultsTo: _task.title);
    var editedNotes = prompt.get('New task note:', defaultsTo: _task.notes ?? '', allowMultiline: true);
    var editedDueDate =
        prompt.get('New due date, example "2020-01-01":', defaultsTo: dateFromDateTime(_task.due) ?? '');
    var dueDate;
    if (editedDueDate == 'null') {
      dueDate = null;
    } else if (editedDueDate != null && editedDueDate != '') {
      dueDate = DateTime.parse(editedDueDate += 'T00:00:00.0Z');
    }
    if (editedNotes == 'null') editedNotes = '';
    await taskListsRepository.updateTask(_list.id, _task.id,
        newTitle: editedTitle, newNotes: editedNotes, newDueDate: dueDate);
  }
}
