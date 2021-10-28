import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/gui/to_do_list/to_do_list_screen.dart';
import 'package:to_do/gui/to_do_list/todo_list_view_model.dart';
import '../mock_data_source/mock_data_source.dart';

void main() {

  Widget createWidgetForTesting({required Widget child}){
    return MaterialApp(
      home: child,
    );
  }

  GetIt.I.registerSingleton<ToDoDataSource>(MockTodoDataSource());

  group('Todo List Test', () {
    testWidgets('First tap shows all items', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: ChangeNotifierProvider(
        create: (_) => TodoListViewModel()..init(),
        child: ToDoListScreen(),
      )));

      await tester.pump();
      expect(find.byType(ListView), findsOneWidget);

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Description 1"), findsOneWidget);

      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Description 2"), findsOneWidget);

      expect(find.text("Title 3"), findsOneWidget);
      expect(find.text("Description 3"), findsOneWidget);
    });

    testWidgets('Tabbar is existed or not', (tester) async {

      await tester.pumpWidget(createWidgetForTesting(child: ChangeNotifierProvider(
        create: (_) => TodoListViewModel()..init(),
        child: ToDoListScreen(),
      )));

      await tester.pump();

      expect(find.byTooltip("Incomplete"), findsOneWidget);
      await tester.tap(find.byTooltip("Incomplete"));
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsNothing);
      expect(find.text("Description 1"), findsNothing);

      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Description 2"), findsOneWidget);

      expect(find.text("Title 3"), findsOneWidget);
      expect(find.text("Description 3"), findsOneWidget);

      expect(find.byTooltip("Completed"), findsOneWidget);
      await tester.tap(find.byTooltip("Completed"));
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget, reason: "not found title 1");
      expect(find.text("Description 1"), findsOneWidget);

      expect(find.text("Title 2"), findsNothing);
      expect(find.text("Description 2"), findsNothing);

      expect(find.text("Title 3"), findsNothing);
      expect(find.text("Description 3"), findsNothing);
    });

    testWidgets('Check an item in completed list', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: ChangeNotifierProvider(
        create: (_) => TodoListViewModel()..init(),
        child: const ToDoListScreen(),
      )));

      await tester.pump();

      expect(find.byTooltip("Completed"), findsOneWidget, reason: "not found completed button");
      await tester.tap(find.byTooltip("Completed"));

      await tester.pumpAndSettle();


      expect(find.byType(Checkbox), findsWidgets);
      await tester.tap(find.byType(Checkbox).first);

      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsNothing);
      expect(find.text("Description 1"), findsNothing);

      expect(find.text("Title 2"), findsNothing);
      expect(find.text("Description 2"), findsNothing);

      expect(find.text("Title 3"), findsNothing);
      expect(find.text("Description 3"), findsNothing);


      expect(find.byTooltip("Incomplete"), findsOneWidget);
      await tester.tap(find.byTooltip("Incomplete").first);
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Description 1"), findsOneWidget);

      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Description 2"), findsOneWidget);

      expect(find.text("Title 3"), findsOneWidget);
      expect(find.text("Description 3"), findsOneWidget);


      expect(find.byTooltip("All"), findsOneWidget);
      await tester.tap(find.byTooltip("All").first);
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Description 1"), findsOneWidget);

      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Description 2"), findsOneWidget);

      expect(find.text("Title 3"), findsOneWidget);
      expect(find.text("Description 3"), findsOneWidget);
    });



    testWidgets('Check an item in incomplete list', (tester) async {

      await tester.pumpWidget(createWidgetForTesting(child: ChangeNotifierProvider(
        create: (_) => TodoListViewModel()..init(),
        child: const ToDoListScreen(),
      )));

      await tester.pump();

      expect(find.byTooltip("Incomplete"), findsOneWidget);
      await tester.tap(find.byTooltip("Incomplete").first);

      await tester.pumpAndSettle();

      expect(find.byType(Checkbox), findsWidgets);
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsNothing);
      expect(find.text("Description 1"), findsNothing);

      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Description 2"), findsOneWidget);

      expect(find.text("Title 3"), findsOneWidget);
      expect(find.text("Description 3"), findsOneWidget);


      expect(find.byTooltip("Completed"), findsOneWidget);
      await tester.tap(find.byTooltip("Completed").first);
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Description 1"), findsOneWidget);

      expect(find.text("Title 2"), findsNothing);
      expect(find.text("Description 2"), findsNothing);

      expect(find.text("Title 3"), findsNothing);
      expect(find.text("Description 3"), findsNothing);


      expect(find.byTooltip("All"), findsOneWidget);
      await tester.tap(find.byTooltip("All").first);
      await tester.pumpAndSettle();

      expect(find.text("Title 1"), findsOneWidget);
      expect(find.text("Description 1"), findsOneWidget);

      expect(find.text("Title 2"), findsOneWidget);
      expect(find.text("Description 2"), findsOneWidget);

      expect(find.text("Title 3"), findsOneWidget);
      expect(find.text("Description 3"), findsOneWidget);
    });
  });
}
