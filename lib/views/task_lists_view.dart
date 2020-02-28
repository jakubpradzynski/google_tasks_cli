import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';
import 'package:google_tasks_cli/views/task_list_view.dart';
import 'package:google_tasks_cli/views/view.dart';
import 'package:prompts/prompts.dart' as prompt;

class TaskListsView extends View {
  TaskListsView(TaskListsRepository taskListsRepository) : super(taskListsRepository);

  @override
  Future<Selectable> render() async {
    await super.render();
    var taskListsOrOption = getTaskLists() + _getAllowedOptions();
    var selectedTaskListsOrOption = prompt.choose('Select list', taskListsOrOption);
    if (selectedTaskListsOrOption == END) return END;
    if (selectedTaskListsOrOption == REFRESH) return REFRESH;
    if (selectedTaskListsOrOption == ADD_NEW_LIST) return await _addNewTaskList();
    return TaskListView(taskListsRepository, selectedTaskListsOrOption as TaskList).render();
  }

  Future<Selectable> _addNewTaskList() async {
    var newListName = prompt.get('New list name:');
    await taskListsRepository.addTaskList(newListName);
    return TaskListsView(taskListsRepository).render();
  }

  List<Selectable> getTaskLists() => taskListsRepository.taskLists.map((taskList) => taskList as Selectable).toList();

  List<Selectable> _getAllowedOptions() => [ADD_NEW_LIST, REFRESH, END];
}
