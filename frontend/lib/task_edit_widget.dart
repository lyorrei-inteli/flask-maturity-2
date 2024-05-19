import 'package:flutter/material.dart';
import 'package:flutter_application/services/tasks_api_service.dart';
import 'package:flutter_application/models/task.dart';

class TaskEditWidget extends StatefulWidget {
  final Task? task;

  TaskEditWidget({this.task});

  @override
  _TaskEditWidgetState createState() => _TaskEditWidgetState();
}

class _TaskEditWidgetState extends State<TaskEditWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _text;
  late bool _status;

  @override
  void initState() {
    super.initState();
    _text = widget.task?.text ?? '';
    _status = widget.task?.status ?? false;
  }

  void _saveTask(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_text);
      print(_status);
      if (widget.task == null) {
        await TasksApiService().createTask(_text);
      } 
      else {
        await TasksApiService().updateTaskName(widget.task!.id, _text);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _text,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _text = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:() => _saveTask(context),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
