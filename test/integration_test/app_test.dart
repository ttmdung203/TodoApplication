import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/gui/to_do_list/to_do_list_screen.dart';
import 'package:to_do/gui/to_do_list/todo_list_view_model.dart';

import 'package:to_do/main.dart' as app;
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';

import '../mock_data_source/mock_data_source.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    Widget createWidgetForTesting({required Widget child}) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets('user switch item: mark completed and incomplete for todo items.', (WidgetTester tester) async {
      GetIt.instance.registerSingleton<ToDoDataSource>(MockTodoDataSource());
      await tester.pumpWidget(createWidgetForTesting(
          child: ChangeNotifierProvider(
        create: (_) => TodoListViewModel()..init(),
        child: const ToDoListScreen(),
      )));

      await tester.pump();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Title 3"), findsOneWidget);

      await tester.tap(find.byTooltip("Incomplete"));
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsNothing);
      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Title 3"), findsOneWidget);

      await tester.tap(find.byTooltip("Completed"));
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Title 2"), findsNothing);
      expect(find.text("Title 3"), findsNothing);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsNothing);
      expect(find.text("Title 2"), findsNothing);
      expect(find.text("Title 3"), findsNothing);

      await tester.tap(find.byTooltip("Incomplete"));
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Title 3"), findsOneWidget);

      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Title 3"), findsNothing);
    });

    testWidgets('User add new item', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(
          child: ChangeNotifierProvider(
        create: (_) => TodoListViewModel()..init(),
        child: const ToDoListScreen(),
      )));

      await tester.pump();

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), "demo Title");
      await tester.enterText(find.byType(TextFormField).at(1), "demo Description");
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));

      var items = await GetIt.instance.get<ToDoDataSource>().loadIncompleteItems();

      expect(items.last.title, "demo Title");
      expect(items.last.description, "demo Description");
      expect(items.last.priority, Priority.medium);
      expect(items.last.status, Status.incomplete);

      await tester.pumpAndSettle();

      expect(find.byTooltip("All"), findsOneWidget);
      expect(find.byTooltip("Incomplete"), findsOneWidget);
      expect(find.byTooltip("Completed"), findsOneWidget);

      expect(find.text("demo Title"), findsOneWidget);
      expect(find.text("demo Description"), findsOneWidget);

      await tester.tap(find.byTooltip("Incomplete"));
      await tester.pumpAndSettle();

      expect(find.text("demo Title"), findsOneWidget);
      expect(find.text("demo Description"), findsOneWidget);

      await tester.tap(find.byTooltip("Completed"));
      await tester.pumpAndSettle();

      expect(find.text("demo Title"), findsNothing);
      expect(find.text("demo Description"), findsNothing);
    });
  });
}
