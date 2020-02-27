import 'package:google_tasks_cli/google/api_authentication_service.dart';
import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/notifier/tasks_for_today_notifier.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';
import 'package:google_tasks_cli/views/task_lists_view.dart';
import 'package:googleapis/tasks/v1.dart';

class GoogleTasksCLI {
  TasksApiService _tasksApiService;

  Future<void> run() async {
    var authClient = await ApiAuthenticationService.fromEnvironmentVariables().getAuthorizedClient();
    _tasksApiService = TasksApiService(TasksApi(authClient));

    var taskListsRepository = TaskListsRepository(_tasksApiService);
    await taskListsRepository.synchronizeData();

    await TasksForTodayNotifier(taskListsRepository).notify();

    while (true) {
      var selectedOption = await TaskListsView(taskListsRepository).render();
      if (selectedOption == REFRESH) {
        await taskListsRepository.synchronizeData();
      }
      if (selectedOption == END) {
        break;
      }
    }
    authClient.close();
  }
}
