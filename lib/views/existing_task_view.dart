import 'dart:io';

import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class ExistingTaskView extends View {
  final TaskList _list;
  final Task _task;

  ExistingTaskView(TasksApiService tasksApiService, this._list, this._task) : super(tasksApiService);

  @override
  Future<Selectable> render() async {
    await super.render();
    var selectedOption = prompt.choose('What do you want to do with your task? - ${_task}', [EDIT, MARK_AS_COMPLETE, DELETE, END]);
    if (selectedOption == END) return END;
    if (selectedOption == EDIT) {
      var editedTitle = prompt.get('Edit your task:', defaultsTo: _task.title);
      await tasksApiService.updateTaskTitle(_list.id, _task.id, editedTitle);
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