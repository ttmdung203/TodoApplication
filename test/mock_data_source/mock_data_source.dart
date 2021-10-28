import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';
import 'package:to_do/models/to_do_item.dart';

class MockTodoDataSource extends ToDoDataSource {

  var list = [
    ToDoItem()
      ..id = 1
      ..title = "Title 1"
      ..description = 'Description 1'
      ..priority = Priority.medium
      ..status = Status.completed,
    ToDoItem()
      ..id = 2
      ..title = "Title 2"
      ..description = 'Description 2'
      ..priority = Priority.low
      ..status = Status.incomplete,
    ToDoItem()
      ..id = 3
      ..title = "Title 3"
      ..description = 'Description 3'
      ..priority = Priority.high
      ..status = Status.incomplete,
  ];

  @override
  Future createToDoItem(ToDoItem item) {
    list.add(item);
    return Future.value();
  }

  @override
  Future<List<ToDoItem>> loadCompletedItems() {
    return Future.value(list.where((element) => element.status == Status.completed).toList());
  }

  @override
  Future<List<ToDoItem>> loadIncompleteItems() {
    return Future.value(list.where((element) => element.status == Status.incomplete).toList());
  }

  @override
  Future<List<ToDoItem>> loadAllTodoItems() {
    return Future.value(list);
  }

  @override
  Future updateToDoItem(ToDoItem item) {
    var index = list.indexWhere((element) => element.id == item.id);
    list[index] = item;
    return Future.value();
  }

}