import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/task_list_view.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class TaskListsView extends View {
  TaskListsView(TasksApiService tasksApiService) : super(tasksApiService);

  @override
  Future<Selectable> render() async {
    var taskLists = await tasksApiService.getTaskLists();
    var selectedList = prompt.choose('Select list', taskLists);
    return TaskListView(tasksApiService, selectedList).render();
  }
}