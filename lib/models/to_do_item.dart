import 'package:flutter/cupertino.dart';
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';

class ToDoItem {
  int? id;
  String title = "";
  String description = "";
  Priority priority = Priority.medium;
  Status status = Status.incomplete;

  @override
  bool operator ==(Object other) {
    return id == (other as ToDoItem).id && id != null;
  }

  @override
  int get hashCode => hashValues(id, title);

}