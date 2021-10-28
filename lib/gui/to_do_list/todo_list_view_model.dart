import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:to_do/helper/app_configuration.dart';
import 'package:to_do/models/status.dart';
import 'package:to_do/models/to_do_item.dart';

class TodoListViewModel with ChangeNotifier {

  final _dataSource = AppConfiguration.instance.getTodoDataSource();

  List<ToDoItem> _completedTodoItems = [];
  List<ToDoItem> _incompleteTodoItems = [];
  List<ToDoItem> _allTodoItems = [];

  UnmodifiableListView<ToDoItem> get completedItems => UnmodifiableListView(_completedTodoItems);
  UnmodifiableListView<ToDoItem> get incompleteItems => UnmodifiableListView(_incompleteTodoItems);
  UnmodifiableListView<ToDoItem> get allTodoItems => UnmodifiableListView(_allTodoItems);

  void init() async {
    _loadAllItems();
    _loadCompletedItems();
    _loadIncompleteItems();
  }

  void _loadAllItems() async {
    _allTodoItems = await _dataSource.loadAllTodoItems();
    notifyListeners();
  }

  void _loadCompletedItems() async {
    _completedTodoItems = await _dataSource.loadCompletedItems();
    notifyListeners();
  }

  void _loadIncompleteItems() async {
    _incompleteTodoItems = await _dataSource.loadIncompleteItems();
    notifyListeners();
  }

  void onUpdateItemStatus(ToDoItem item, Status status) async {
    if (item.status == Status.incomplete) {
      var index = _incompleteTodoItems.indexOf(item);

      if (status != item.status) {
        item.status = status;
        _incompleteTodoItems.removeAt(index);
        _completedTodoItems.add(item);
      } else {
        _incompleteTodoItems[index] = item;
      }
    } else if (item.status == Status.completed) {
      var index = _completedTodoItems.indexOf(item);
      if (status != item.status) {
        item.status = status;
        _completedTodoItems.removeAt(index);
        _incompleteTodoItems.add(item);
      } else {
        _completedTodoItems[index] = item;
      }
    }
    item.status = status;
    await _dataSource.updateToDoItem(item);
    notifyListeners();
  }

  void onAddTodoItem(ToDoItem todoItem) {
    _loadIncompleteItems();
    _loadAllItems();
  }
}