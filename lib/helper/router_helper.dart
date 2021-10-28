import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/gui/add_todo_screen/add_todo_screen.dart';
import 'package:to_do/gui/add_todo_screen/add_todo_view_model.dart';
import 'package:to_do/gui/to_do_list/to_do_list_screen.dart';
import 'package:to_do/gui/to_do_list/todo_list_view_model.dart';

class RouterFactory {

  static Widget todoListPage() {
    return ChangeNotifierProvider(
      create: (_) => TodoListViewModel()..init(),
      child: const ToDoListScreen(),
    );
  }

  static MaterialPageRoute addTodoPageRoute() {
    return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
      create: (_) => AddTodoViewModel(),
      child: const AddTodoScreen(),
    ));
  }
}
