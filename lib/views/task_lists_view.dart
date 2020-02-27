import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';
import 'package:google_tasks_cli/views/task_list_view.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class TaskListsView extends View {
  TaskListsView(TaskListsRepository taskListsRepository) : super(taskListsRepository);

  @override
  Future<Selectable> render() async {
    await super.render();
    var taskLists = taskListsRepository.taskLists;
    var taskListsOrOption = taskLists.map((taskList) => taskList as Selectable).toList() + [ADD_NEW_LIST, REFRESH, END];
    var selectedTaskListsOrOption = prompt.choose('Select list', taskListsOrOption);
    if (selectedTaskListsOrOption == END) return END;
    if (selectedTaskListsOrOption == REFRESH) return REFRESH;
    if (selectedTaskListsOrOption == ADD_NEW_LIST) {
      var newListName = prompt.get('New list name');
      await taskListsRepository.addTaskList(newListName);
      return TaskListsView(taskListsRepository).render();
    }
    return TaskListView(taskListsRepository, selectedTaskListsOrOption as TaskList).render();
  }
}
