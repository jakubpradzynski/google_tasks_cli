import 'package:google_tasks_cli/google/tasks_api_service.dart';
import 'package:google_tasks_cli/models.dart';
import 'package:google_tasks_cli/repositories/task_lists_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockTasksApiService extends Mock implements TasksApiService {}

void main() {
  var mockTasksApiService = MockTasksApiService();
  var taskListsRepository = TaskListsRepository(mockTasksApiService);
  test('should synchronize data', () async {
    // GIVEN
    var taskList1 = TaskList('taskListId1', 'taskList1');
    var taskList2 = TaskList('taskListId2', 'taskList2');
    var taskInList1 = Task('taskId1', 'title1', 'needs_action', 'notes', DateTime.now());
    var taskInList2 = Task('taskId2', 'title2', 'completed', null, null);
    when(mockTasksApiService.getTaskLists()).thenAnswer((_) => Future.value([taskList1, taskList2]));
    when(mockTasksApiService.getTasks('taskListId1', showHidden: true)).thenAnswer((_) => Future.value([taskInList1]));
    when(mockTasksApiService.getTasks('taskListId2', showHidden: true)).thenAnswer((_) => Future.value([taskInList2]));

    // WHEN
    await taskListsRepository.synchronizeData();

    // THEN
    expect(taskListsRepository.getTaskListById('taskListId1'), taskList1);
    expect(taskListsRepository.getTaskListById('taskListId2'), taskList2);
    expect(taskListsRepository.getTasks('taskListId1'), [taskInList1]);
    expect(taskListsRepository.getTasks('taskListId2'), [taskInList2]);
  });

  test('should return tasks for today', () async {
    // GIVEN
    var taskList = TaskList('listId', 'taskList1');
    var todayTask = Task('taskId', 'title', 'needs_action', 'notes', DateTime.now());
    var otherTask = Task('taskId', 'title', 'needs_action', 'notes', DateTime.now().add(Duration(days: 1)));
    when(mockTasksApiService.getTaskLists()).thenAnswer((_) => Future.value([taskList]));
    when(mockTasksApiService.getTasks('listId', showHidden: true))
        .thenAnswer((_) => Future.value([todayTask, otherTask]));

    // WHEN
    await taskListsRepository.synchronizeData();

    // THEN
    expect(taskListsRepository.getTasksForToday(), {
      taskList: [todayTask]
    });
  });

  test('should add new task list', () async {
    // GIVEN
    when(mockTasksApiService.addTaskList('newList')).thenAnswer((_) => Future.value(TaskList('id', 'newList')));

    // WHEN
    await taskListsRepository.addTaskList('newList');

    // THEN
    expect(taskListsRepository.getTaskListById('id').title, 'newList');
  });

  test('should add new task to list', () async {
    // GIVEN
    when(mockTasksApiService.addTaskList('newList')).thenAnswer((_) => Future.value(TaskList('id', 'newList')));
    await taskListsRepository.addTaskList('newList');
    when(mockTasksApiService.addTaskToList('id', 'newTask'))
        .thenAnswer((_) => Future.value(Task('taskId', 'newTask', 'needs_action', null, null)));

    // WHEN
    await taskListsRepository.addTaskToList('id', 'newTask');

    // THEN
    expect(taskListsRepository.getTasks('id').length, 1);
    expect(taskListsRepository.getTasks('id').first.title, 'newTask');
  });

  test('should mark task as complete', () async {
    // GIVEN
    await prepareListWithTask(mockTasksApiService, taskListsRepository);
    when(mockTasksApiService.markTaskAsComplete('id', 'taskId'))
        .thenAnswer((_) => Future.value(Task('taskId', 'newTask', 'completed', null, null)));

    // WHEN
    await taskListsRepository.markTaskAsComplete('id', 'taskId');

    // THEN
    expect(taskListsRepository.getTasks('id').length, 1);
    expect(taskListsRepository.getTasks('id').first.status, 'completed');
  });

  test('should delete task', () async {
    // GIVEN
    await prepareListWithTask(mockTasksApiService, taskListsRepository);

    // WHEN
    await taskListsRepository.deleteTask('id', 'taskId');

    // THEN
    verify(mockTasksApiService.deleteTask('id', 'taskId'));
    expect(taskListsRepository.getTasks('id').length, 0);
  });

  test('should delete tasks', () async {
    // GIVEN
    await prepareListWithTask(mockTasksApiService, taskListsRepository);
    when(mockTasksApiService.addTaskToList('id', 'newTask2'))
        .thenAnswer((_) => Future.value(Task('taskId2', 'newTask2', 'needs_action', null, null)));
    await taskListsRepository.addTaskToList('id', 'newTask2');

    // WHEN
    await taskListsRepository.deleteTasks('id', ['taskId', 'taskId2']);

    // THEN
    verify(mockTasksApiService.deleteTask('id', 'taskId'));
    verify(mockTasksApiService.deleteTask('id', 'taskId2'));
    expect(taskListsRepository.getTasks('id').length, 0);
  });

  test('should update task list title', () async {
    // GIVEN
    await prepareListWithTask(mockTasksApiService, taskListsRepository);
    when(mockTasksApiService.updateTaskListTitle('id', 'newListName'))
        .thenAnswer((_) => Future.value(TaskList('id', 'newListName')));

    // WHEN
    await taskListsRepository.updateTaskListTitle('id', 'newListName');

    // THEN
    expect(taskListsRepository.getTaskListById('id').title, 'newListName');
  });

  test('should delete task list', () async {
    // GIVEN
    await prepareListWithTask(mockTasksApiService, taskListsRepository);

    // WHEN
    await taskListsRepository.deleteTaskList('id');

    // THEN
    verify(mockTasksApiService.deleteTaskList('id'));
    expect(taskListsRepository.getTaskListById('id'), null);
  });
}

Future prepareListWithTask(MockTasksApiService mockTasksApiService, TaskListsRepository taskListsRepository) async {
  when(mockTasksApiService.addTaskList('newList')).thenAnswer((_) => Future.value(TaskList('id', 'newList')));
  await taskListsRepository.addTaskList('newList');
  when(mockTasksApiService.addTaskToList('id', 'newTask'))
      .thenAnswer((_) => Future.value(Task('taskId', 'newTask', 'needs_action', null, null)));
  await taskListsRepository.addTaskToList('id', 'newTask');
}
