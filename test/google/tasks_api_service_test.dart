import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockTasksApi extends Mock implements TasksApi {}
class MockTasklistsResourceApi extends Mock implements TasklistsResourceApi {}
class MockTasksResourceApi extends Mock implements TasksResourceApi {}

void main() {
  var tasksApiMock = MockTasksApi();
  var tasklistsResourceApiMock = MockTasklistsResourceApi();
  var tasksResourceApi = MockTasksResourceApi();
  var tasksApiService = TasksApiService(tasksApiMock);

  setUp(() {
    when(tasksApiMock.tasklists).thenReturn(tasklistsResourceApiMock);
    when(tasksApiMock.tasks).thenReturn(tasksResourceApi);
  });

  test('should return task lists', () async {
    // GIVEN
    var taskList = TaskList.fromJson({
      'id': 'id',
      'title': 'title'
    });
    var taskLists = TaskLists.fromJson({'items': [taskList.toJson()]});

    when(tasklistsResourceApiMock.list()).thenAnswer((_) => Future.value(taskLists));

    // WHEN
    var result = await tasksApiService.getTaskLists();

    // THEN
    expect(result.length, 1);
    expect(result.first.id, 'id');
    expect(result.first.title, 'title');
  });

  test('should return empty task lists', () async {
    // GIVEN
    when(tasksApiMock.tasklists).thenReturn(tasklistsResourceApiMock);
    when(tasklistsResourceApiMock.list()).thenAnswer((_) => Future.value(TaskLists.fromJson({})));
    
    // WHEN
    var result = await tasksApiService.getTaskLists();
    
    // THEN
    expect(result.length, 0);
  });

  test('should return tasks', () async {
    // GIVEN
    var task = Task.fromJson({
      'id': 'id',
      'title': 'title'
    });
    var tasks = Tasks.fromJson({'items': [task.toJson()]});

    when(tasksResourceApi.list('listId')).thenAnswer((_) => Future.value(tasks));

    // WHEN
    var result = await tasksApiService.getTasks('listId');

    // THEN
    expect(result.length, 1);
    expect(result.first.id, 'id');
    expect(result.first.title, 'title');
  });

  test('should return empty tasks', () async {
    // GIVEN
    when(tasksResourceApi.list('listId')).thenAnswer((_) => Future.value(Tasks.fromJson({})));

    // WHEN
    var result = await tasksApiService.getTasks('listId');

    // THEN
    expect(result.length, 0);
  });

  test('should add new task to list', () async {
    // GIVEN
    var taskRequest = Task()..title = 'title';
    var task = Task.fromJson({
      'id': 'id',
      'title': 'title'
    });

    when(tasksResourceApi.insert(any, 'listId')).thenAnswer((_) => Future.value(task));

    // WHEN
    var result = await tasksApiService.addTaskToList('listId', 'newTask');

    // THEN
    expect(result.id, isNot(null));
    expect(result.title, 'title');
  });

}
