import 'package:get_it/get_it.dart';
import 'package:to_do/data/local_todo_data_source.dart';
import 'package:to_do/data/todo_data_source.dart';

class AppConfiguration {

  static AppConfiguration get instance => _instance;
  static final AppConfiguration _instance = AppConfiguration._privateConstructor();

  AppConfiguration._privateConstructor();

  void configure() {
    GetIt.I.registerSingleton<ToDoDataSource>(LocalTodoDataSource());
  }

  ToDoDataSource getTodoDataSource() {
    return GetIt.instance.get<ToDoDataSource>();
  }
}