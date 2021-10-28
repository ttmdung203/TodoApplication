import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:to_do/gui/add_todo_screen/add_todo_view_model.dart';
import 'package:to_do/models/priority.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Todo"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pop(null);
          }, icon: const Icon(Icons.close)),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
          child: ChangeNotifierProvider(
            create: (_) => AddTodoViewModel(),
            child: _inputTodoForm(),
          ),
        ),
      ),
    );
  }

  Widget _inputTodoForm() {
    return Consumer<AddTodoViewModel>(builder: (context, model, _) {
      if (model.isLoading) {
        EasyLoading.show(status: 'Processing');
      } else {
        EasyLoading.dismiss();
      }
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title'),
              _titleTextField(model.title),
              const SizedBox(height: 36),
              const Text('Description'),
              _descriptionTextField(model.description),
              const SizedBox(height: 36),
              const Text('Priority'),
              _priorityDropdown(model.priority),
              const SizedBox(height: 36),
              _submitButton(),
            ],
          ),
        ),
      );
    });
  }

  Widget _titleTextField(String initTitle) {
    return TextFormField(
      initialValue: initTitle,
      decoration: const InputDecoration(hintText: "Please enter title"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      validator: (text) {
        if (text != null && text.isNotEmpty) {
          return null;
        } else {
          return 'Title must be not empty';
        }
      },
      onChanged: (text) {
        Provider.of<AddTodoViewModel>(context, listen: false).updateTitle(text);
      },
    );
  }


  Widget _descriptionTextField(String initDescription) {
    return TextFormField(
      initialValue: initDescription,
      decoration: const InputDecoration(hintText: "Please enter description"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.next,
      validator: (text) {
        if (text != null && text.isNotEmpty) {
          return null;
        } else {
          return 'Description must be not empty';
        }
      },
      onChanged: (text) {
        Provider.of<AddTodoViewModel>(context, listen: false).updateDescription(text);
      },
    );
  }

  Widget _priorityDropdown(Priority initPriority) {
    return DropdownButtonFormField(
      items: Priority.values.map((e) => DropdownMenuItem(child: Text(e.stringValue()), value: e)).toList(),
      value: initPriority,
      onChanged: (value) {
        if (value is Priority) Provider.of<AddTodoViewModel>(context, listen: false).updatePriority(value);
      },
    );
  }

  Widget _submitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final todo = await Provider.of<AddTodoViewModel>(context, listen: false).onSubmitTodo();
            Navigator.of(context).pop(todo);
          }
        },
        child: const SizedBox(child: Center(child: Text('Submit')), height: 50),
      ),
    );
  }
}
