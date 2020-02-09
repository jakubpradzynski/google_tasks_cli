import 'package:google_tasks_cli/google/api_authentication_service.dart';
import 'package:google_tasks_cli/google/models.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/views/task_lists_view.dart';
import 'package:googleapis/tasks/v1.dart';

class GoogleTasksCLI {
  TasksApiService _tasksApiService;

  Future<void> run() async {
    var authClient = await ApiAuthenticationService.fromEnvironmentVariables().getAuthorizedClient();
    _tasksApiService = TasksApiService(TasksApi(authClient));
    _clearConsole();

    while (true) {
      print('Google Tasks CLI');
      var selectedOption = await TaskListsView(_tasksApiService).render();
      if (selectedOption == END) {
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


