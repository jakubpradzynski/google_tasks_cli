class TaskList extends Selectable {
  TaskList(id, title) : super(id, title);
}

class Task extends Selectable {
  Task(id, title): super(id, title);
}

class PredefinedOption extends Selectable {
  PredefinedOption(id, title): super(id, title);

  @override
  String toString() => '----- $_title -----';
}

var END = PredefinedOption('1', 'END');
var DELETE = PredefinedOption('2', 'DELETE');
var EDIT = PredefinedOption('3', 'EDIT');
var ADD_NEW_TASK = PredefinedOption('4', 'ADD NEW TASK');
var MARK_AS_COMPLETE = PredefinedOption('5', 'MARK AS COMPLETE');
var REFRESH_LIST = PredefinedOption('6', 'REFRESH LIST');
var DO_NOTHING = PredefinedOption('7', 'DO NOTHING');

abstract class Selectable {
  final String _id;
  final String _title;

  Selectable(this._id, this._title);

  String get id => _id;
  String get title => _title;

  @override
  String toString() => _title;
}