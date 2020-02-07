import 'package:google_tasks_cli/google/api_authentication_service.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:prompts/prompts.dart' as prompt;

class GoogleTasksCLI {
  TasksApiService _tasksApiService;

  Future<void> run() async {
    _clearConsole();
    var authClient = await ApiAuthenticationService.fromEnvironmentVariables().getAuthorizedClient();
    _tasksApiService = TasksApiService(TasksApi(authClient));

    while (true) {
      print('Google Tasks CLI');
      var taskLists = await _tasksApiService.getTaskLists();
      var selectedList = prompt.choose('Select list', taskLists);
      print('Selected list - $selectedList');
      var wantAddNewTask = prompt.getBool('Do you want to add new task?', defaultsTo: false);
      if (wantAddNewTask) {
        var taskToAdd = prompt.get('Your task');
        await _tasksApiService.addTaskToList(selectedList.id, taskToAdd);
      }
      var tasks = await _tasksApiService.getTasks(selectedList.id);
      tasks.forEach((x) => print(x));
      var wantToLeave = prompt.getBool('Do you want to leave?', defaultsTo: false);
      if (wantToLeave) {
        break;
      }
      _clearConsole();
    }
    authClient.close();
  }

  void _clearConsole() {
    print('\x1B[2J\x1B[0;0H');
  }
}


