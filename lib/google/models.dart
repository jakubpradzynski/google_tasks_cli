class TaskList extends Selectable {
  TaskList(id, title) : super(id, title);
}

class Task extends Selectable {
  Task(id, title): super(id, title);
}


abstract class Selectable {
  final String _id;
  final String _title;

  Selectable(this._id, this._title);

  String get id => _id;
  String get title => _title;

  @override
  String toString() => _title;
}