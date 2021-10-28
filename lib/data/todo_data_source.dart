import 'package:to_do/models/to_do_item.dart';

abstract class ToDoDataSource {

  Future<List<ToDoItem>> loadCompletedItems();
  Future<List<ToDoItem>> loadIncompleteItems();
  Future<List<ToDoItem>> loadAllTodoItems();

  Future createToDoItem(ToDoItem item);
  Future updateToDoItem(ToDoItem item);
}