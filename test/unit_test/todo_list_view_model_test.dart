
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/gui/to_do_list/todo_list_view_model.dart';
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';
import 'package:to_do/models/to_do_item.dart';

import '../mock_data_source/mock_data_source.dart';

void main() {
  GetIt.I.registerSingleton<ToDoDataSource>(MockTodoDataSource());
  var viewModel = TodoListViewModel()..init();


  group('TodListModel load list', () {
    test('load completed list', () async {
      var completedItems = viewModel.completedItems;

      expect(completedItems.length, 1);

      expect(completedItems[0].id, 1);
      expect(completedItems[0].title, "Title 1");
      expect(completedItems[0].description, "Description 1");
      expect(completedItems[0].priority, Priority.medium);
      expect(completedItems[0].status, Status.completed);
    });
    test('load incomplete list', () {
      var inCompleteItems = viewModel.incompleteItems;
      expect(inCompleteItems.length, 2);

      expect(inCompleteItems[0].id, 2);
      expect(inCompleteItems[0].title, "Title 2");
      expect(inCompleteItems[0].description, "Description 2");
      expect(inCompleteItems[0].priority, Priority.low);
      expect(inCompleteItems[0].status, Status.incomplete);

      expect(inCompleteItems[1].id, 3);
      expect(inCompleteItems[1].title, "Title 3");
      expect(inCompleteItems[1].description, "Description 3");
      expect(inCompleteItems[1].priority, Priority.high);
      expect(inCompleteItems[1].status, Status.incomplete);
    });
  });

  group('todo list view model: update todo item', () {
    test('update todo item status', () {
      viewModel.onUpdateItemStatus(viewModel.completedItems[0], Status.incomplete);
      expect(viewModel.incompleteItems.length, 3);
      expect(viewModel.completedItems.length, 0);
    });
    test('update todo item status', () {
      viewModel.onUpdateItemStatus(viewModel.incompleteItems[0], Status.completed);
      expect(viewModel.incompleteItems.length, 2);
      expect(viewModel.completedItems.length, 1);
    });
  });

  group('todo list view model: add new todo item', () {
    test('add a new todo item', () async {
      var viewModel = TodoListViewModel()..init();
      var item = ToDoItem()
        ..id = 4
        ..title = "Title 4"
        ..description = 'Description 4'
        ..priority = Priority.medium
        ..status = Status.incomplete;
      await GetIt.instance.get<ToDoDataSource>().createToDoItem(item);
      viewModel.onAddTodoItem(item);

      await Future.delayed(const Duration(seconds: 2), (){});

      expect(viewModel.allTodoItems.length, 4);
      expect(viewModel.incompleteItems.length, 3);
      expect(viewModel.completedItems.length, 1);

      expect(viewModel.incompleteItems[2].id, 4);
      expect(viewModel.incompleteItems[2].title, "Title 4");
      expect(viewModel.incompleteItems[2].description, "Description 4");
      expect(viewModel.incompleteItems[2].priority, Priority.medium);
      expect(viewModel.incompleteItems[2].status, Status.incomplete);
    });
  });
}