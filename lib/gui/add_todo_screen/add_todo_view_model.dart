import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/helper/app_configuration.dart';
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';
import 'package:to_do/models/to_do_item.dart';

class AddTodoViewModel with ChangeNotifier {
  final _dataSource = AppConfiguration.instance.getTodoDataSource();
  String _title = '';
  String _description = '';
  Priority _priority = Priority.medium;
  bool _isLoading = false;

  String get title => _title;

  String get description => _description;

  Priority get priority => _priority;

  bool get isLoading => _isLoading;

  void updateTitle(String title) {
    _title = title;
  }

  void updateDescription(String description) {
    _description = description;
  }

  void updatePriority(Priority priority) {
    _priority = priority;
  }

  Future<ToDoItem> onSubmitTodo() async {
    _isLoading = true;
    notifyListeners();
    var item = ToDoItem()
      ..title = _title
      ..description = _description
      ..status = Status.incomplete
      ..priority = _priority;
    await _dataSource.createToDoItem(item);
    _isLoading = false;
    notifyListeners();
    return item;
  }
}
