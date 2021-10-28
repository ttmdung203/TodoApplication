
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/gui/add_todo_screen/add_todo_view_model.dart';
import 'package:to_do/models/priority.dart';
import '../mock_data_source/mock_data_source.dart';

void main() {
  GetIt.I.registerSingleton<ToDoDataSource>(MockTodoDataSource());
  var viewModel = AddTodoViewModel();


  group('AddTodoViewModel Update data', () {
    test('Update title', () async {
      viewModel.updateTitle('new title');
      expect(viewModel.title, 'new title');
    });
    test('Update description', () async {
      viewModel.updateDescription('new description');
      expect(viewModel.description, 'new description');
    });
    test('Update priority', () async {
      viewModel.updatePriority(Priority.high);
      expect(viewModel.priority, Priority.high);
    });
  });

  group('AddTodoViewModel submit item', () {
    test('Check update correct item', () async {
      var item = await viewModel.onSubmitTodo();
      expect(item.title, "new title");
      expect(item.description, "new description");
      expect(item.priority, Priority.high);
    });
  });
}