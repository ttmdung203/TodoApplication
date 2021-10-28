import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/gui/add_todo_screen/add_todo_screen.dart';
import 'package:to_do/gui/add_todo_screen/add_todo_view_model.dart';
import 'package:to_do/gui/to_do_list/todo_list_view_model.dart';
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';

import '../mock_data_source/mock_data_source.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  GetIt.I.registerSingleton<ToDoDataSource>(MockTodoDataSource());

  group('Add todo test', () {
    testWidgets('validate title inline error message', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: ChangeNotifierProvider(
        create: (_) =>
        AddTodoViewModel(),
        child: AddTodoScreen(),
      )));

      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();
      expect(find.text('Title must be not empty'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, "demo title");
      await tester.pumpAndSettle();
      expect(find.text('Title must be not empty'), findsNothing);
    });

    testWidgets('validate description inline error message', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: ChangeNotifierProvider(
        create: (_) =>
          AddTodoViewModel(),
        child: AddTodoScreen(),
      )));

      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();
      expect(find.text('Description must be not empty'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(1), "demo Description");
      await tester.pumpAndSettle();
      expect(find.text('Description must be not empty'), findsNothing);
    });

    testWidgets('Test if submit button can create a new todo item', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: ChangeNotifierProvider(
        create: (_) =>
          AddTodoViewModel(),
        child: AddTodoScreen(),
      )));

      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), "demo Title");
      await tester.enterText(find.byType(TextFormField).at(1), "demo Description");
      await tester.tap(find.byType(ElevatedButton));

      await tester.pumpAndSettle();

      var items = await GetIt.instance.get<ToDoDataSource>().loadIncompleteItems();

      expect(items.length, 3);

      expect(items.last.title, "demo Title");
      expect(items.last.description, "demo Description");
      expect(items.last.priority, Priority.medium);
      expect(items.last.status, Status.incomplete);

    });
  });
}