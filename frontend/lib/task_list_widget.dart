import 'package:flutter/material.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/models/task.dart';
import 'package:flutter_application/task_edit_widget.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({super.key});

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await ApiService().getTasks();
    setState(() {});
  }

  void _toggleTaskStatus(int id, bool status) async {
    await ApiService().updateTaskStatus(id, status);
    loadTasks();
  }

  void _editTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskEditWidget(task: task)),
    ).then((_) => loadTasks());
  }

  void _deleteTask(int id) async {
    await ApiService().deleteTask(id);
    loadTasks(); // Reloads the list after deleting a task
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/create-task')
                .then((_) => loadTasks()),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = tasks[index];
          return ListTile(
            title: Text(task.text),
            subtitle: Text('Status: ${task.status ? 'Completed' : 'To do'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: task.status,
                  onChanged: (bool? newValue) {
                    _toggleTaskStatus(task.id, newValue!);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editTask(task), // Assuming you have a method for this
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(task.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
