import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/gui/to_do_list/todo_card_widget.dart';
import 'package:to_do/gui/to_do_list/todo_list_view_model.dart';
import 'package:to_do/helper/router_helper.dart';
import 'package:to_do/models/status.dart';
import 'package:to_do/models/to_do_item.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  var selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Todo List'),
          actions: [IconButton(onPressed: onPressAddTodo, icon: const Icon(Icons.add))],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.language), label: "All"),
            BottomNavigationBarItem(icon: Icon(Icons.language), label: "Incomplete"),
            BottomNavigationBarItem(icon: Icon(Icons.done_all), label: "Completed"),
          ],
          currentIndex: selectedTabIndex,
          onTap: (index) {
            setState(() {
              selectedTabIndex = index;
            });
          },
        ),
        // bottomNavigationBar:
        body: _selectedListViewWidget(),
      ),
    );
  }

  void onPressAddTodo() async {
    var todoItem = await Navigator.of(context).push(RouterFactory.addTodoPageRoute());
    if (todoItem != null) {
      Provider.of<TodoListViewModel>(context, listen: false).onAddTodoItem(todoItem);
    }
  }

  Widget _selectedListViewWidget() {
    return Consumer<TodoListViewModel>(builder: (_, model, __) {
      List<ToDoItem> todoItems = [];
      switch (selectedTabIndex) {
        case 0:
          todoItems = model.allTodoItems;
          break;
        case 1:
          todoItems = model.incompleteItems;
          break;
        case 2:
          todoItems = model.completedItems;
          break;
        default:
          return Container();
      }
      if (todoItems.isEmpty) {
        return Center(
          child: TextButton(
            child: const Text(
              "Empty list.\nClick here to add new one.",
              style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            onPressed: onPressAddTodo,
          ),
        );
      } else {
        return _listViewWidget(todoItems, model);
      }
    });
  }

  Widget _listViewWidget(List<ToDoItem> todoItems, TodoListViewModel model) {
    return ListView.builder(
      itemCount: todoItems.length,
      itemBuilder: (itemContext, index) {
        return TodoCardWidget(
            item: todoItems[index],
            onChanged: (value) {
              model.onUpdateItemStatus(
                todoItems[index],
                value ? Status.completed : Status.incomplete,
              );
            });
      },
    );
  }
}
