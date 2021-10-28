import 'package:flutter/material.dart';
import 'package:to_do/models/priority.dart';
import 'package:to_do/models/status.dart';
import 'package:to_do/models/to_do_item.dart';

class TodoCardWidget extends StatefulWidget {
  final ValueChanged onChanged;
  final ToDoItem item;

  const TodoCardWidget({Key? key, required this.item, required this.onChanged}) : super(key: key);

  @override
  State<TodoCardWidget> createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(3)), boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset.zero,
          blurRadius: 8,
          spreadRadius: 3,
        ),
      ]),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(value: widget.item.status == Status.completed, onChanged: widget.onChanged),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Text(widget.item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: null)),
                  const SizedBox(height: 12),
                  Flexible(child: Text(widget.item.description, style: const TextStyle(fontSize: 16), maxLines: null))
                ],
              ),
            ),
            _priorityTag(widget.item.priority),
          ],
        ),
      ),
    );
  }

  Widget _priorityTag(Priority priority) {
    Color color = Colors.green;
    switch (priority) {
      case Priority.high:
        color = Colors.redAccent;
        break;
      case Priority.low:
        color = Colors.black26;
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 8),
      height: 30,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: color.withAlpha(30),

      ),
      child: Center(child: Text(priority.stringValue(), textAlign: TextAlign.center, style: TextStyle(color: color),)),
    );
  }
}
