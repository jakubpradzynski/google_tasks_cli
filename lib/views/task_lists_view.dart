import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/task_list_view.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class TaskListsView extends View {
  TaskListsView(TasksApiService tasksApiService) : super(tasksApiService);

  @override
  Future<Selectable> render() async {
    await super.render();
    var taskLists = await tasksApiService.getTaskLists();
    var taskListsOrOption = taskLists.map((taskList) => taskList as Selectable).toList() + [ADD_NEW_LIST, END];
    var selectedTaskListsOrOption = prompt.choose('Select list', taskListsOrOption);
    if (selectedTaskListsOrOption == END) return END;
    if (selectedTaskListsOrOption == ADD_NEW_LIST) {
      var newListName = prompt.get('New list name');
      await tasksApiService.addTaskList(newListName);
      return TaskListsView(tasksApiService).render();
    }
    return TaskListView(tasksApiService, selectedTaskListsOrOption as TaskList).render();
  }
}
