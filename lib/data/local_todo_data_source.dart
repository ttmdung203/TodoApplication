import 'package:sqflite/sqflite.dart';
import 'package:to_do/data/todo_data_source.dart';
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';
import 'package:to_do/models/to_do_item.dart';
import 'package:path/path.dart';

enum TodoFields { id, title, description, status, priority }

extension TodoFieldsExtension on TodoFields {
  String value() {
    switch (this) {
      case TodoFields.id:
        return "id";
      case TodoFields.title:
        return "title";
      case TodoFields.description:
        return "description";
      case TodoFields.status:
        return "status";
      case TodoFields.priority:
        return "priority";
      default:
        return "";
    }
  }
  static TodoFields? fromInt(int value) {
    switch (value) {
      case 1:
        return TodoFields.id;
      case 2:
        return TodoFields.title;
      case 3:
        return TodoFields.description;
      case 4:
        return TodoFields.status;
      case 5:
        return TodoFields.priority;
      default:
        return null;
    }
  }
}

class LocalTodoDataSource extends ToDoDataSource {
  Database? _database;
  final _tableName = 'todo';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    await _setup();
    return _database!;
  }

  Future _setup() async {
    var path = await getDatabasesPath();
    path = join(path, "todo.db");
    print("path = $path");
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        final query = 'CREATE TABLE $_tableName ( '
            '${TodoFields.id.value()} INTEGER primary key AUTOINCREMENT NOT NULL, '
            '${TodoFields.title.value()} TEXT, '
            '${TodoFields.description.value()} TEXT, '
            '${TodoFields.status.value()} INTEGER, '
            '${TodoFields.priority.value()} INTEGER)';
        await db.execute(query);
      },
    );
  }

  @override
  Future updateToDoItem(ToDoItem item) async {
    await (await database).insert(_tableName, item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future createToDoItem(ToDoItem item) async {
    await (await database).insert(_tableName, item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  }

  @override
  Future<List<ToDoItem>> loadCompletedItems() async {
    List<Map> maps = await (await database).query(_tableName, columns: null, where: 'status = ' + Status.completed.index.toString());
    return maps.map((e) => TodoItemExtension.fromMap(e)).toList().reversed.toList();
  }

  @override
  Future<List<ToDoItem>> loadIncompleteItems() async {
    List<Map> maps = await (await database).query(_tableName, columns: null, where: 'status = ' + Status.incomplete.index.toString());
    return maps.map((e) => TodoItemExtension.fromMap(e)).toList().reversed.toList();
  }

  @override
  Future<List<ToDoItem>> loadAllTodoItems() async {
    List<Map> maps = await (await database).query(_tableName, columns: null);
    return maps.map((e) => TodoItemExtension.fromMap(e)).toList().reversed.toList();
  }
}

extension TodoItemExtension on ToDoItem {
  static ToDoItem fromMap(Map e) {
    return ToDoItem()
      ..id = e[TodoFields.id.value()]
      ..title = e[TodoFields.title.value()]
      ..description = e[TodoFields.description.value()]
      ..status = StatusExtension.fromValue(e[TodoFields.status.value()]) ?? Status.incomplete
      ..priority = PriorityExtension.fromValue(e[TodoFields.priority.value()]) ?? Priority.medium;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      TodoFields.title.value(): title,
      TodoFields.description.value(): description,
      TodoFields.priority.value(): priority.index.toString(),
      TodoFields.status.value(): status.index.toString(),
    };
    if (id != null) {
      map[TodoFields.id.value()] = id;
    }
    return map;
  }
}
