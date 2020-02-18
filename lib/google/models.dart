class TaskList extends Selectable {
  TaskList(id, title) : super(id, title);
}

class Task extends Selectable {
  final String _status;
  final String _notes;
  final DateTime _due;

  Task(id, title, this._status, this._notes, this._due) : super(id, title);

  String get status => _status;

  String get notes => _notes;

  DateTime get due => _due;

  @override
  String toString() {
    if (status == 'completed') {
      return '+ ' + super.toString() + ' +';
    }
    return super.toString();
  }
}

class PredefinedOption extends Selectable {
  PredefinedOption(id, title) : super(id, title);

  @override
  String toString() => '----- $_title -----';
}

var END = PredefinedOption('1', 'END');
var DELETE_TASK = PredefinedOption('2', 'DELETE TASK');
var EDIT_TASK = PredefinedOption('3', 'EDIT TASK');
var ADD_NEW_TASK = PredefinedOption('4', 'ADD NEW TASK');
var MARK_AS_COMPLETE = PredefinedOption('5', 'MARK AS COMPLETE');
var REFRESH_LIST = PredefinedOption('6', 'REFRESH LIST');
var DO_NOTHING = PredefinedOption('7', 'DO NOTHING');
var SHOW_COMPLETED = PredefinedOption('8', 'SHOW COMPLETED');
var HIDE_COMPLETED = PredefinedOption('9', 'HIDE COMPLETED');
var CLEAR_COMPLETED_TASKS = PredefinedOption('10', 'CLEAR COMPLETED TASKS');
var ADD_NEW_LIST = PredefinedOption('10', 'ADD NEW LIST');
var DELETE_LIST = PredefinedOption('11', 'DELETE LIST');
var EDIT_LIST_NAME = PredefinedOption('12', 'EDIT LIST NAME');
var BACK = PredefinedOption('13', 'BACK');

abstract class Selectable {
  final String _id;
  final String _title;

  Selectable(this._id, this._title);

  String get id => _id;

  String get title => _title;

  @override
  String toString() => _title;
}
